package Jikkoku::Service::BattleCommand::Battle::TargetOverriderResult {

  use Mouse::Role;
  use Jikkoku;

  has 'giver' => ( is => 'ro', isa => 'Jikkoku::Service::BattleCommand::Battle::Chara', required => 1 );

  requires qw( after_override_battle_target_service_class_name );

}

1;

