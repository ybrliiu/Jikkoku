package Jikkoku::Class::ExtensiveState::BattleTargetOverriderResult {

  use Mouse;
  use Jikkoku;

  has 'extensive_state' => (
    is       => 'ro',
    does     => 'Jikkoku::Class::ExtensiveState::ExtensiveState',
    required => 1,
  );

  with qw( Jikkoku::Service::BattleCommand::Battle::TargetOverriderResult );

  sub after_override_battle_target_service_class_name {
    my $self = shift;
    $self->extensive_state->after_override_battle_target_service_class_name;
  }

  __PACKAGE__->meta->make_immutable;

}

1;

