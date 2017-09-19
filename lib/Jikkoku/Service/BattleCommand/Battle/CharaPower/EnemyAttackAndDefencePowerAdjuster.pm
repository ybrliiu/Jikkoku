package Jikkoku::Service::BattleCommand::Battle::CharaPower::EnemyAttackAndDefencePowerAdjuster {

  use Mouse::Role;
  use Jikkoku;

  with qw(
    Jikkoku::Service::BattleCommand::Battle::CharaPower::EnemyAttackPowerAdjuster
    Jikkoku::Service::BattleCommand::Battle::CharaPower::EnemyDefencePowerAdjuster
  );

}

1;

