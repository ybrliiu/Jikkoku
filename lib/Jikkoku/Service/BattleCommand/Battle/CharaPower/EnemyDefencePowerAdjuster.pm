package Jikkoku::Service::BattleCommand::Battle::CharaPower::EnemyDefencePowerAdjuster {

  use Mouse::Role;
  use Jikkoku;

  with 'Jikkoku::Service::BattleCommand::Battle::CharaPower::EnemyPowerAdjuster';

  # methods
  requires qw( adjust_enemy_defence_power );

  around adjust_enemy_defence_power => sub {
    my ($orig, $self, $enemy_power_adjuster_service) = @_;
    $enemy_power_adjuster_service->orig_enemy_defence_power < 0 ? 0 : $self->$orig();
  };

}

1;

__END__

=head1

sub adjust_enemy_defence_power($enemy_power_adjuster_service : AdjusterService::EnemyPower) : Num

=cut

