package Jikkoku::Service::BattleCommand::Battle::CharaPower::EnemyAttackPowerAdjuster {

  use Mouse::Role;
  use Jikkoku;

  with 'Jikkoku::Service::BattleCommand::Battle::CharaPower::EnemyPowerAdjuster';

  requires qw( adjust_enemy_attack_power );

}

1;

__END__

=head1

sub adjust_enemy_attack_power($enemy_power_adjuster_service : AdjusterService::EnemyPower) : Num

=cut

