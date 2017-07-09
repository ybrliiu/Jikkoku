package Jikkoku::Service::BattleCommand::Battle::TargetOverrider {

  use Mouse::Role;
  use Jikkoku;

  requires qw(
    override_battle_target
    after_override_battle_target_service_class_name
  );

}

1;

