package Jikkoku::Class::State::Role::DecreaseAttackPower {

  use Mouse::Role;
  use Jikkoku;

  with 'Jikkoku::Class::State::Role::AttackPowerAdjuster';

  sub description {
    my $self = shift;
    '攻撃力が' + $self->attack_power_ratio * 100 * -1 + '%低下する。';
  }

}

1;

