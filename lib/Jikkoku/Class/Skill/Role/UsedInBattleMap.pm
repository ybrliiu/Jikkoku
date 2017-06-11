package Jikkoku::Class::Skill::Role::UsedInBattleMap {

  use Mouse::Role;
  use Jikkoku;

  use Carp;
  use List::Util;
  use Jikkoku::Util qw( validate_values );

  # attribute
  requires qw( consume_morale );

  has 'map_log_model'    => ( is => 'rw' );
  has 'battle_map_model' => ( is => 'rw' );

  # method
  requires qw( effect_time );

  around description_of_status_about_consume_morale => sub {
    my ($orig, $self) = @_;
    "消費士気 : @{[ $self->consume_morale ]}";
  };

}

1;

__END__

Jikkoku::Class::Skill::Skill
+ Jikkoku::Class::Skill::Role::DependOnAbilities

