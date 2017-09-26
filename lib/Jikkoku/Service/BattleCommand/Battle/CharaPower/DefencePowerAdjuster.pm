package Jikkoku::Service::BattleCommand::Battle::CharaPower::DefencePowerAdjuster {

  use Mouse::Role;
  use Jikkoku;

  with 'Jikkoku::Service::BattleCommand::Battle::CharaPower::CharaPowerAdjuster'; 

  # methods
  requires qw( adjust_defence_power );

}

1;

__END__

=head1

sub adjust_defence_power($self, $chara_power_adjuster_service : AdjusterService::CharaPower) : Num

=cut
