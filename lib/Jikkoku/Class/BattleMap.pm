package Jikkoku::Class::BattleMap {

  use v5.14;
  use warnings;
  use Class::Accessor::Lite new => 0;

  use Carp qw/croak/;

  use Jikkoku::Class::BattleMap::Node;
  use Jikkoku::Class::BattleMap::CheckPoint;

  use constant {
    # shorcut
    Node => 'Jikkoku::Class::BattleMap::Node',
  };

  {
    my %attributes = (
      id           => undef,
      name         => undef,
      width        => undef,
      height       => undef,
      map_data     => [],
      check_points => {},
    );

    Class::Accessor::Lite->mk_accessors( keys %attributes );

    sub new {
      my ($class, $args) = @_;
      my $self = bless {%attributes, %$args}, $class;
      $self->set_nodes;
      # $self->set_edges_node;
      $self->set_check_points;
      $self;
    }
  }

  sub set_nodes {
    my ($self) = @_;
    $self->loop(sub {
      # 第1引数 は まだNode Obj でない( terrain )
      my ($terrain, $y, $x) = @_;
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
        terrain => $terrain || 0,
      });
      $self->{map_data}[$y][$x] = $new_node;
    });
  }

  sub set_edges_node {
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

  sub set_check_points {
    my ($self) = @_;
    for my $point (keys %{ $self->{check_points} }) {
      my $check_point = Jikkoku::Class::BattleMap::CheckPoint->new( $self->{check_points}{$point} );
      $self->{check_points}{$point} = $check_point; 
      my $check_point_node = $self->{map_data}[ $check_point->y ][ $check_point->x ];
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
    for my $i (0 .. $self->{height} - 1) {
      for my $j (0 .. $self->{width} - 1) {
        my $node = $self->{map_data}[$i][$j];
        $code->($node, $i, $j);
      }
    }
  }

  sub get_node_by_point {
    my ($self, $x, $y) = @_;
    $self->{map_data}[$y][$x];
  }

  sub get_node {
    my ($self, $code) = @_;
    for my $i (0 .. $self->{height} - 1) {
      for my $j (0 .. $self->{width} - 1) {
        my $node = $self->{map_data}[$i][$j];
        unless ($node eq '') {
          my $ret = $code->($node);
          return $node if $ret;
        }
      }
    }
  }

  sub get_up_node {
    my ($self, $node) = @_;
    return undef if $node->y - 1 < 0;
    $self->{map_data}[ $node->y - 1 ][ $node->x ];
  }
  
  sub get_down_node {
    my ($self, $node) = @_;
    return undef if $node->y + 1 >= $self->{height};
    $self->{map_data}[ $node->y + 1 ][ $node->x ];
  }
  
  sub get_right_node {
    my ($self, $node) = @_;
    return undef if $node->x + 1 >= $self->{width};
    $self->{map_data}[ $node->y ][ $node->x + 1 ];
  }
  
  sub get_left_node {
    my ($self, $node) = @_;
    return undef if $node->x - 1 < 0;
    $self->{map_data}[ $node->y ][ $node->x - 1 ];
  }

  sub get_check_point {
    my ($self, $node) = @_;
    my $point = $node->y . ',' . $node->x;
    $self->check_points->{$point} // croak "関所が見つかりませんでした (y,x) = ($point)";
  }

}

1;
