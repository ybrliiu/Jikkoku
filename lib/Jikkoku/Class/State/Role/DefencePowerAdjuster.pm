package Jikkoku::Class::State::Role::DefencePowerAdjuster {

  use Mouse::Role;
  use Jikkoku;

  # attributes
  requires qw( defence_power_ratio defence_power );

  with 'Jikkoku::Service::BattleCommand::Battle::CharaPower::DefencePowerAdjuster';

  sub adjust_defence_power {
    my ($self, $orig_defence_power) = @_;
    $orig_defence_power * $self->defence_power_ratio + $self->defence_power;
  }

}

1;

