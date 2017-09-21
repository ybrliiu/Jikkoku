package Jikkoku::Class::Chara::Soldier {

  use Mouse;
  use Jikkoku;

  extends 'Jikkoku::Class::Soldier';

  use List::Util qw( sum );
  use Jikkoku::Util 'validate_values';
  
  has 'chara' => (
    is       => 'ro',
    isa      => 'Jikkoku::Class::Chara::ExtChara',
    handles  => { training => 'soldier_training' },
    weak_ref => 1,
  );

  override max_move_point => sub {
    my $self = shift;
    my $orig_cost = super();
    my $cost = $orig_cost;
    $cost += sum(
      map { $_->adjust_soldier_max_move_point($orig_cost) }
        @{
          $self->chara->skills
            ->get_available_skills_with_result
            ->get_soldier_max_move_point_adjuster_skills_with_result
        }
    );
    $cost;
  };

  sub occur_action_time {
    my ($self, $value) = @_;
    Carp::croak 'few argments($value)' if @_ < 2;
    my $soldier_bm = $self->chara->_soldier_battle_map;
    if ( $soldier_bm->get('action_time') < $value ) {
      $soldier_bm->set( action_time => $value );
    }
  }

  sub occur_move_point_charge_time {
    my ($self, $value) = @_;
    Carp::croak 'few argments($value)' if @_ < 2;
    $value += sum(
      map { $_->adjust_soldier_charge_move_point_time($value) }
        @{
          $self->chara->skills
            ->get_available_skills_with_result
            ->get_soldier_charge_move_point_time_adjuster_skills_with_result
        }
    );
    my $soldier_bm = $self->chara->_soldier_battle_map;
    if ( $soldier_bm->get('move_point_charge_time') < $value ) {
      $soldier_bm->set( move_point_charge_time => $value );
    }
  }

  sub charge_move_point {
    my ($self, $charge_time) = @_;
    Carp::croak 'few argments($charge_time)' if @_ < 2;
    $self->chara->_soldier_battle_map->set(move_point => $self->max_move_point);
    $self->occur_move_point_charge_time($charge_time);
  }

  sub distance_from_point {
    my ($self, $point) = @_;
    Carp::croak 'few argments($point)' if @_ < 2;
    abs($self->x - $point->x) + abs($self->y - $point->y);
  }

  sub distance_from_coordinate {
    my ($self, $x, $y) = @_;
    Carp::croak 'few argments($x, $y)' if @_ < 2;
    abs($self->x - $x) + abs($self->y - $y);
  }

  # 本当は別名メソッドに分けたいけどいい名前が思いつかなかったので統合...
  sub is_same_position {
    my $self = shift;
    if (@_ == 2) {
      my ($bm_id, $point) = @_;
      $self->battle_map_id eq $bm_id    &&
      $self->x             == $point->x &&
      $self->y             == $point->y;
    }
    elsif (@_ == 3) {
      my ($bm_id, $x, $y) = @_;
      $self->battle_map_id == $bm_id &&
      $self->x             == $x     &&
      $self->y             == $y;
    }
    else {
      Carp::croak 'invalid argments( ($bm_id, $point) or ($bm_id, $x, $y) )';
    }
  }

  # coordinate = $x, $y 指定
  # point      = ->x, ->y を呼べるオブジェクト

  sub is_same_position_as_coordinate {
    my ($self, $bm_id, $x, $y) = @_;
    Carp::croak 'few argments($bm_id, $x, $y)' if @_ < 4;
    $self->battle_map_id == $bm_id &&
    $self->x             == $x     &&
    $self->y             == $y;
  }

  sub is_same_position_as_point {
    my ($self, $bm_id, $point) = @_;
    Carp::croak 'few argments($bm_id, $point)' if @_ < 3;
    $self->battle_map_id eq $bm_id    &&
    $self->x             == $point->x &&
    $self->y             == $point->y;
  }

  sub is_same_position_as_soldier {
    my ($self, $soldier) = @_;
    Carp::croak 'few argments($soldier)' if @_ < 2;
    $self->battle_map_id eq $soldier->battle_map_id &&
    $self->x             == $soldier->x             &&
    $self->y             == $soldier->y
  }

  sub is_same_point {
    my ($self, $point) = @_;
    Carp::croak 'few argments($point)' if @_ < 2;
    $self->x == $point->x && $self->y == $point->y;
  }

  sub is_same_point_as_coordinate {
    my ($self, $x, $y) = @_;
    Carp::croak 'few arguments($x, $y)' if @_ < 3;
    $self->x == $x && $self->y == $y;
  }

  sub set_coordinate_by_point {
    my ($self, $node) = @_;
    Carp::croak 'few argments ($node)' if @_ < 2;
    my $soldier_battle_map = $self->chara->_soldier_battle_map;
    $soldier_battle_map->set(x => $node->x);
    $soldier_battle_map->set(y => $node->y);
  }

  sub set_coordinate_by_coordinate {
    my ($self, $x, $y) = @_;
    Carp::croak 'few argments ($x, $y)' if @_ < 3;
    my $soldier_battle_map = $self->chara->_soldier_battle_map;
    $soldier_battle_map->set(x => $x);
    $soldier_battle_map->set(y => $y);
  }

  sub sortie_to_staying_towns_castle {
    my ($self, $battle_map_model) = @_;
    Carp::croak 'few argments($battle_map_model)' if @_ < 2;
    my $battle_map  = $battle_map_model->get_battle_map( $self->chara->town_id );
    my $castle_node = $battle_map->get_castle_node;
    $self->sortie($battle_map, $castle_node);
  }

  sub sortie_to_around_staying_town {
    my ($self, $args) = @_;
    validate_values $args => [qw/ battle_map_model x y /];
    my $battle_map = $args->{battle_map_model}->get_battle_map( $self->chara->town_id );
    my $stay_node  = $battle_map->get_node_by_coordinate( $args->{x}, $args->{y} );
    Carp::confess 'そのマスにはいけません' unless $stay_node->can_stay;
    $self->sortie($battle_map, $stay_node);
  }

  sub sortie_to_adjacent_town {
    my ($self, $args) = @_;
    validate_values $args => [qw/ battle_map_model adjacent_town_id /];
    my $battle_map = $args->{battle_map_model}->get_between_town_battle_map({
      start_town_id  => $self->chara->town_id,
      target_town_id => $args->{adjacent_town_id},
    });
    my $entry_node = $battle_map->get_node(sub {
      my $node = shift;
      if ($node->terrain == $node->ENTRY) {
        return $node->check_point->target_bm_id == $self->chara->town_id;
      }
    });
    $self->sortie($battle_map, $entry_node);
  }

  sub sortie {
    my ($self, $battle_map, $node) = @_;
    Carp::confess '既に出撃しています' if $self->is_sortie;
    $self->is_sortie(1);
    $self->battle_map_id( $battle_map->id );
    $self->set_coordinate_by_point($node);
  }

  sub num {
    my $self = shift;
    $self->chara->soldier_num(@_);
  }

  sub move_battle_map {
    my ($self, $bm_id, $node) = @_;
    Carp::croak 'few argments($bm_id, $node)' if @_ < 2;
    $self->battle_map_id($bm_id);
    $self->set_coordinate_by_point($node);
  }

  sub retreat {
    my $self = shift;

    $self->is_sortie(0);
    $self->$_('') for qw( x y battle_map_id );
    $self->$_(0)  for qw( action_time move_point_charge_time );
    $self->chara->_soldier_battle_map->set($_ => 0)  for qw( keisu_count plus_attack_power plus_defence_power );

    $self->chara->_interval_time->init;
    $self->chara->_debuff->init;
  }

  # ailias methods

  sub _add_meta_method {
    my $class = shift;

    for my $method_name ( qw/
      x y formation_id battle_map_id is_sortie
      move_point_charge_time move_point action_time change_formation_time
    / ) {
      $class->_add_alias_method($method_name, '_soldier_battle_map');
    }

    for my $method_name (qw/ morale morale_max /) {
      $class->_add_alias_method($method_name, '_morale_data');
    }

  }

  sub _add_alias_method {
    my ($class, $method_name, $attr_name) = @_;
    $class->meta->add_method($method_name => sub {
      my $self = shift;
      if (@_) {
        $self->chara->$attr_name->set($method_name => shift);
      } else {
        $self->chara->$attr_name->get($method_name);
      }
    });
  }

  __PACKAGE__->_add_meta_method;

  __PACKAGE__->meta->make_immutable;

}

package Jikkoku::Class::Chara::SoldierException {

  use Jikkoku;
  use parent 'Jikkoku::Exception';

}

1;
