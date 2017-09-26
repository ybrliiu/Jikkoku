package Jikkoku::Service::BattleCommand::Battle::CharaPower::EnemyDefencePowerAdjuster {

  use Mouse::Role;
  use Jikkoku;

  with 'Jikkoku::Service::BattleCommand::Battle::CharaPower::EnemyPowerAdjuster';

  # methods
  requires qw( adjust_enemy_defence_power );

}

1;

__END__

=head1

sub adjust_enemy_defence_power($enemy_power_adjuster_service : AdjusterService::EnemyPower) : Num

=cut

