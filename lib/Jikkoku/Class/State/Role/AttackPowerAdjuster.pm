package Jikkoku::Class::State::Role::AttackPowerAdjuster {

  use Mouse::Role;
  use Jikkoku;

  # attributes
  requires qw( attack_power_ratio );

  with 'Jikkoku::Service::BattleCommand::Battle::CharaPower::AttackPowerAdjuster';

  sub adjust_attack_power {
    my ($self, $orig_attack_power) = @_;
    $orig_attack_power * $self->attack_power_ratio;
  }

}

1;

