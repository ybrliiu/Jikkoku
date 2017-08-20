package Jikkoku::Class::State::Role::AttackPowerAdjuster {

  use Mouse::Role;
  use Jikkoku;

  requires qw( attack_power_ratio );

  sub description {
    my $self = shift;
    '攻撃力' . $self->attack_power_ratio * 100 . '%。';
  }

}

1;

