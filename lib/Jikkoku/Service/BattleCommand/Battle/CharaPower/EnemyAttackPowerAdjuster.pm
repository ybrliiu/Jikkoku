package Jikkoku::Service::BattleCommand::Battle::CharaPower::EnemyAttackPowerAdjuster {

  use Mouse::Role;
  use Jikkoku;

  requires qw( adjust_enemy_attack_power );

}

1;

__END__

=head1

sub adjust_enemy_attack_power($orig_attack_power) : Int

=cut

