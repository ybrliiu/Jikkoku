package Jikkoku::Class::Skill::Role::BattleAction {

  use Mouse::Role;
  use Jikkoku;

  use Jikkoku::Util qw( validate_values );

  has 'map_log_model'    => (is => 'rw');
  has 'battle_map_model' => (is => 'rw');

  with 'Jikkoku::Class::Role::BattleAction';

  before ensure_can_action => sub {
    my ($self, $args) = @_;
    validate_values $args => [qw( map_log_model battle_map_model )];
    $self->map_log_model( $args->{map_log_model} );
    $self->battle_map_model( $args->{battle_map_model} );

    throw( $self->name . 'スキルを修得していません。' ) unless $self->is_acquired;
  };

}

1;
