package Jikkoku::Service::BattleCommand::Battle::CharaPower::DefencePowerAdjuster {

  use Mouse::Role;
  use Jikkoku;

  with 'Jikkoku::Service::BattleCommand::Battle::CharaPower::CharaPowerAdjuster'; 

  # methods
  requires qw( adjust_defence_power );

  around adjust_defence_power => sub {
    my ($orig, $self, $chara_power_adjuster_service) = @_;
    $chara_power_adjuster_service->orig_defence_power < 0 ? 0 : $self->$orig();
  };

}

1;

__END__

=head1

sub adjust_defence_power($chara_power_adjuster_service : AdjusterService::CharaPower) : Num

=cut
