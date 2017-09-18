package Jikkoku::Service::BattleCommand::Battle::CharaPower::AttackAndDefencePowerAdjuster {

  use Mouse::Role;
  use Jikkoku;

  with qw(
    Jikkoku::Service::BattleCommand::Battle::CharaPower::AttackPowerAdjuster
    Jikkoku::Service::BattleCommand::Battle::CharaPower::DefencePowerAdjuster
  );

}

1;

