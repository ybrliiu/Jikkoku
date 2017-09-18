package Jikkoku::Service::BattleCommand::Battle::CharaPower::EnemyDefencePowerAdjuster {

  use Mouse::Role;
  use Jikkoku;

  with 'Jikkoku::Service::BattleCommand::Battle::CharaPower::EnemyPowerAdjuster';

  requires qw( adjust_enemy_defence_power );

}

1;

__END__

=head1

sub adjust_enemy_defence_power($orig_defence_power) : Int

=cut

