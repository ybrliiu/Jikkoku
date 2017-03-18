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

  with 'Jikkoku::Class::Role::BattleAction';

  # method
  requires qw(
    calc_success_pc
    effect_time
    calc_effect_time
  );

  before ensure_can_action => sub {
    my ($self, $args) = @_;
    validate_values $args => [qw( map_log_model battle_map_model )];
    $self->map_log_model( $args->{map_log_model} );
    $self->battle_map_model( $args->{battle_map_model} );

    throw( $self->name . 'スキルを修得していません。' ) unless $self->is_acquired;
  };

}

1;

__END__

Jikkoku::Class::Skill::Skill
+ Jikkoku::Class::Skill::Role::DependOnAbilities

