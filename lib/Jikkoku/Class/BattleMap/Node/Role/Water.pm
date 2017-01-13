package Jikkoku::Class::BattleMap::Node::Role::Water {

  use Jikkoku;
  use Role::Tiny;

  use Carp;

  sub WATER_NAVY_COST() { 1 }
  sub BOG_NAVY_COST()   { 2 }
  sub LAND_NAVY_TIMES() { 5 }

  around new => sub {
    my ($orig, $class, $args) = @_;
    my $self = $class->$orig($args);
    Carp::croak "水地形ではありません" unless $self->is_water;
    $self;
  };

  around origin_cost => sub {
    my ($orig, $self, $chara) = @_;
    if ( $chara->soldier->attr eq '水' ) {
      if (
        $self->{terrain} == $self->WATER_CASTLE ||
        $self->{terrain} == $self->RIVER        ||
        $self->{terrain} == $self->POND         ||
        $self->{terrain} == $self->SEA   
      ) {
        WATER_NAVY_COST();
      }
      elsif ( $self->{terrain} == $self->BOG ) {
        BOG_NAVY_COST();
      }
      else {
        $self->$orig() * LAND_NAVY_TIMES();
      }
    } else {
      $self->$orig();
    }
  };

}

1;
