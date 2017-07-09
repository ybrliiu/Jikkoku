package Jikkoku::Class::ExtensiveState::Role::OverrideBattleTarget {

  use Mouse::Role;
  use Jikkoku;

  with qw( Jikkoku::Service::BattleCommand::Battle::TargetOverrider );

  sub after_override_battle_target_service_class_name {
    my $self = shift;
    $self->service('ExtensiveState::AfterOverrideBattleTarget::' . $self->id);
  }

}

1;

