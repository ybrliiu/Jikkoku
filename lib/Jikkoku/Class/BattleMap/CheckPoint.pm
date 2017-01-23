package Jikkoku::Class::BattleMap::CheckPoint {

  use Jikkoku;
  use Class::Accessor::Lite new => 0;

  {
    my %attributes = (
      x                => undef,
      y                => undef,
      target_bm_id     => undef,
      target_bm_name   => undef,
      target_town_name => undef,
    );

    Class::Accessor::Lite->mk_accessors( keys %attributes );

    sub new {
      my ($class, $args) = @_;
      bless {%attributes, %$args}, $class;
    }
  }

}

1;
