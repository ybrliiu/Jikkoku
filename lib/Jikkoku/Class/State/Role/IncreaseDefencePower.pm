package Jikkoku::Class::State::Role::IncreaseDefencePower {

  use Mouse::Role;
  use Jikkoku;

  with 'Jikkoku::Class::State::Role::DefencePowerAdjuster';

  sub description {
    my $self = shift;
    '守備力が' + $self->defence_power_ratio * 100 + '%+' + $self->defence_power + '上昇する。';
  }

}

1;

