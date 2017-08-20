package Jikkoku::Service::BattleCommand::Battle::CharaPower::AttackPowerAdjuster {

  use Mouse::Role;
  use Jikkoku;

  # methods
  requires qw( adjust_attack_power );

}

1;

__END__

=head1

sub adjust_attack_power($attack_power_orig) : Int

=cut
