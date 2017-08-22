package Jikkoku::Class::State::Role::AttackPowerAdjuster {

  use Mouse::Role;
  use Jikkoku;

  # attributes
  requires qw( attack_power_ratio );

  with 'Jikkoku::Service::BattleCommand::Battle::CharaPower::AttackPowerAdjuster';

  sub adjust_attack_power {
    my ($self, $attack_power_orig) = @_;
    $attack_power_orig * $self->attack_power_ratio;
  }

}

1;

