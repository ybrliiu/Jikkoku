package Jikkoku::Class::BattleMode::Siege {

  use Mouse;
  use Jikkoku;

  has 'name'           => ( is => 'ro', isa => 'Str', default => '強襲' );
  has 'consume_morale' => ( is => 'ro', isa => 'Int', default => 20 );

  with qw(
    Jikkoku::Class::BattleMode::BattleMode
    Jikkoku::Service::BattleCommand::Battle::CharaPower::AttackAndDefencePowerAdjuster
    Jikkoku::Service::BattleCommand::Battle::CharaPower::EnemyAttackAndDefencePowerAdjuster
  );

  sub adjust_attack_power {}

  sub adjust_defence_power {}

  sub adjust_enemy_attack_power {}

  sub adjust_enemy_defence_power {}

  __PACKAGE__->meta->make_immutable;

}

1;

