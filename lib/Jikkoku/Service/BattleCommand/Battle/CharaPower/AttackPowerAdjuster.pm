package Jikkoku::Service::BattleCommand::Battle::CharaPower::AttackPowerAdjuster {

  use Mouse::Role;
  use Jikkoku;

  with 'Jikkoku::Service::BattleCommand::Battle::CharaPower::CharaPowerAdjuster'; 

  # methods
  requires qw( adjust_attack_power );

}

1;

__END__

# charapower の攻撃力を調整するためのメソッドを提供するRole

=head1

sub adjust_attack_power($orig_attack_power) : Int

=cut
