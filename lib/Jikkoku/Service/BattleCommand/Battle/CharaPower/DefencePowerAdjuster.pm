package Jikkoku::Service::BattleCommand::Battle::CharaPower::DefencePowerAdjuster {

  use Mouse::Role;
  use Jikkoku;

  # methods
  requires qw( adjust_defence_power );

}

1;

__END__

=head1

sub adjust_defence_power($orig_defence_power) : Int

=cut
