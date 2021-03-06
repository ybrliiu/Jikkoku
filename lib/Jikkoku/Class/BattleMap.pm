package Jikkoku::Class::BattleMap {

  use Mouse;
  use Jikkoku;

  use Carp qw( croak );
  use Jikkoku::Util qw( validate_values );
  use List::Util qw( first );
  use Option;

  use Jikkoku::Class::BattleMap::Node;
  use Jikkoku::Class::BattleMap::CheckPoint;

  use constant {
    # shorcut
    Node => 'Jikkoku::Class::BattleMap::Node',
  };

  has 'id'           => ( is => 'ro', isa => 'Str',                required => 1 );
  has 'name'         => ( is => 'ro', isa => 'Str',                required => 1 );
  has 'width'        => ( is => 'ro', isa => 'Int',                required => 1 );
  has 'height'       => ( is => 'ro', isa => 'Int',                required => 1 );
  has 'map_data'     => ( is => 'rw', isa => 'ArrayRef[ArrayRef]', required => 1 );
  has 'check_points' => ( is => 'rw', isa => 'HashRef',            required => 1 );

  has 'allies'  => ( is => 'rw', isa => 'ArrayRef[Jikkoku::Class::Chara]' );
  has 'enemies' => ( is => 'rw', isa => 'ArrayRef[Jikkoku::Class::Chara]' );

  sub BUILD {
    my $self = shift;
    $self->set_nodes;
    $self->set_check_points;
  }

  sub is_castle_around_map {
    my $self = shift;
    $self->id !~ /-/;
  }

  sub set_nodes {
    my ($self) = @_;
    $self->loop(sub {
      # 第1引数 は まだNode Obj でない( terrain )
      my ($terrain, $y, $x) = @_;
      $terrain ||= 0;
      my $new_node_class = do {
        if ( $terrain == Node->CASTLE ) {
          Node . '::Castle';
        } elsif ( $terrain == Node->WATER_CASTLE ) {
          Node . '::WaterCastle';
        } elsif ( Node->is_water($terrain) ) {
          Node . '::Water';
        } elsif ( Node->is_check_point($terrain) ){
          Node . '::CheckPoint';
        } else {
          Node;
        }
      };
      my $new_node = $new_node_class->new({
        x       => $x,
        y       => $y,
        terrain => $terrain,
      });
      $self->map_data->[$y][$x] = $new_node;
    });
  }

  sub set_nodes_edge {
    my ($self) = @_;
    $self->loop(sub {
      my ($node) = @_;
      my %around_nodes = (
        up    => $self->get_up_node( $node ),
        down  => $self->get_down_node( $node ),
        right => $self->get_right_node( $node ),
        left  => $self->get_left_node( $node ),
      );
      $node->edges_node( [ map { $_ // () } values %around_nodes ] );
    });
  }

  sub set_current {
    my ($self, $chara) = @_;
    my $node = $self->map_data->[ $chara->soldier_battle_map('y') ][ $chara->soldier_battle_map('x') ];
    $node->current;
  }

  sub set_charactors {
    my ($self, $chara_model, $chara) = @_;
    $self->set_current($chara);
    my $charactors  = $chara_model->get_all;
    my @sortie_list = grep { $_->is_sortie && $_->soldier_battle_map('battle_map_id') eq $self->id } @$charactors;
    my @allies      = grep { $_->country_id == $chara->country_id } grep { $_->id ne $chara->id } @sortie_list;
    my @enemies     = grep { $_->country_id != $chara->country_id } @sortie_list;
    $self->allies( \@allies );
    $self->enemies( \@enemies );
    for my $ally (@allies) {
      my $soldier = $ally->soldier;
      my $node    = $self->map_data->[ $soldier->y ][ $soldier->x ];
      $node->push_ally($ally);
    }
    for my $enemy (@enemies) {
      my $soldier = $enemy->soldier;
      my $node    = $self->map_data->[ $soldier->y ][ $soldier->x ];
      $node->push_enemy($enemy);
    }
  }

  sub can_move {
    my ($self, $args) = @_;
    validate_values $args => [qw( chara direction chara_model town_model )];
    my $chara = $args->{chara};

    my $current_node = $self->get_node_by_point( $chara->soldier );
    my $next_node = do {
      my $method = "get_$args->{direction}_node";
      return unless $self->can($method);
      $self->$method($current_node);
    };
    die "その座標は存在しません" unless defined $next_node;

    if ( $next_node->is_castle ) {
      my $bm_town = $args->{town_model}->get( $self->id );
      die "他国の城の上に移動することはできません" if $bm_town->country_id != $chara->country_id;
    }

    # set_charactors でマップ上に武将がセットされている時のみ
    die "そのマスには敵がいるので移動できません" if @{ $next_node->enemies };

    my $enemy = $args->{chara_model}->first(sub {
      my ($other) = @_;
      $other->is_soldier_same_position($self->id, $next_node->x, $next_node->y)
        && $other->country_id != $chara->country_id;
    });
    die "そのマスには敵がいるので移動できません" if defined $enemy;

    $next_node;
  }

  # 範囲を計算すればいらない(キャッシュしてるので高速化の期待はできる)
  sub set_can_move {
    my ($self, $args) = @_;
    validate_values $args => [qw( chara chara_model town_model )];
    for my $direction (qw/up down right left/) {
      my $move_node = eval { $self->can_move({%$args, direction => $direction}) };
      if (my $e = $@) {
        next;
      } else {
        # soldier can_move
        if ( $args->{chara}->soldier->move_point - $move_node->cost($args->{chara}) >= 0 ) {
          $move_node->can_move_direction($direction);
        }
      }
    }
  }

  sub set_check_points {
    my ($self) = @_;
    for my $point (keys %{ $self->check_points }) {
      my $check_point = Jikkoku::Class::BattleMap::CheckPoint->new( $self->check_points->{$point} );
      $self->check_points->{$point} = $check_point; 
      my $check_point_node = $self->map_data->[ $check_point->y ][ $check_point->x ];
      $check_point_node->check_point( $check_point );
    }
  }

  sub set_town_info {
    my ($self, $town) = @_;
    Carp::croak "引数が足りません" if @_ < 2;
    my $castle = $self->get_node(sub {
      my $node = shift;
      $node->is_castle;
    });
    Carp::croak "城地形が見つかりませんでした" unless defined $castle;
    $castle->set_town_info($town);
  }

  sub loop {
    my ($self, $code) = @_;
    for my $i (0 .. $self->height - 1) {
      for my $j (0 .. $self->width - 1) {
        my $node = $self->map_data->[$i][$j];
        $code->($node, $i, $j);
      }
    }
  }

  sub iter {
    my $self = shift;
    my ($x, $y) = (0, 0);
    sub {
      if ($x == $self->width) {
        $x = 0;
        $y += 1;
      }
      $self->map_data->[$y][$x++];
    };
  }

  sub get_adjacent_node {
    my ($self, $node, $direction) = @_;
    my $method = "get_${direction}_node";
    return unless $self->can($method);
    $self->$method($node);
  }

  sub get_node_by_point {
    my ($self, $point) = @_;
    Carp::croak 'Too few arguments ($point)' if @_ < 2;
    Carp::croak '指定された座標はマップの範囲外です'
      if $point->x < 0 || $point->y < 0 || $point->x >= $self->width || $point->y >= $self->height;
    $self->map_data->[ $point->y ][ $point->x ];
  }

  sub get_node_by_coordinate {
    my ($self, $x, $y) = @_;
    Carp::croak 'Too few arguments ($x, $y)' if @_ < 3;
    Carp::croak '指定された座標はマップの範囲外です'
      if $x < 0 || $y < 0 || $x >= $self->width || $y >= $self->height;
    $self->map_data->[$y][$x];
  }

  sub get_node {
    my ($self, $code) = @_;
    for my $i (0 .. $self->height - 1) {
      for my $j (0 .. $self->width - 1) {
        my $node = $self->map_data->[$i][$j];
        unless ($node eq '') {
          my $ret = $code->($node);
          return $node if $ret;
        }
      }
    }
  }

  sub get_castle_node {
    my $self = shift;
    $self->get_node(sub {
      my $node = shift;
      $node->is_castle;
    });
  }

  sub get_up_node {
    my ($self, $node) = @_;
    return undef if $node->y - 1 < 0;
    $self->map_data->[ $node->y - 1 ][ $node->x ];
  }
  
  sub get_down_node {
    my ($self, $node) = @_;
    return undef if $node->y + 1 >= $self->height;
    $self->map_data->[ $node->y + 1 ][ $node->x ];
  }
  
  sub get_right_node {
    my ($self, $node) = @_;
    return undef if $node->x + 1 >= $self->width;
    $self->map_data->[ $node->y ][ $node->x + 1 ];
  }
  
  sub get_left_node {
    my ($self, $node) = @_;
    return undef if $node->x - 1 < 0;
    $self->map_data->[ $node->y ][ $node->x - 1 ];
  }

  sub get_castle_back_node {
    my ($self, $castle, $castle_next) = @_;
    my ($gap_x, $gap_y) = ($castle_next->x - $castle->x, $castle_next->y - $castle->y);
    my $castle_back = $self->get_node(sub {
      my $node = shift;
      ($node->x == $castle->x - $gap_x) && ($node->y == $castle->y - $gap_y);
    });
  }

  sub get_check_point {
    my ($self, $node) = @_;
    my $point = $node->y . ',' . $node->x;
    $self->check_points->{$point} // croak "関所が見つかりませんでした (y,x) = ($point)";
  }

  sub get_check_point_by_target_bm_id {
    my ($self, $bm_id) = @_;
    Carp::croak 'few argments($bm_id)' if @_ < 2;
    first { $_->target_bm_id eq $bm_id } values %{ $self->check_points };
  }

  sub get_adjacent_check_points {
    my ($self, $soldier) = @_;
    Carp::croak 'Too few arguments (required: $soldier)' if @_ < 2;
    return [] if $self->id ne $soldier->battle_map_id;
    [ grep { $soldier->distance_from_point($_) <= 1 } values %{ $self->check_points } ];
  }

  __PACKAGE__->meta->make_immutable;

}

1;
