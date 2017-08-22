package Jikkoku::Class::State::Role::DecreaseDefencePower {

  use Mouse::Role;
  use Jikkoku;

  with 'Jikkoku::Class::State::Role::DefencePowerAdjuster';

  sub description {
    my $self = shift;
    '守備力が' + $self->defence_power_ratio * 100 * -1 + '%+' + $self->defence_power * -1 + '低下する。';
  }

}

1;

