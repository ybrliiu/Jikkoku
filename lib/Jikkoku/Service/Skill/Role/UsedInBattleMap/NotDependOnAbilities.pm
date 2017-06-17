package Jikkoku::Service::Skill::Role::UsedInBattleMap::NotDependOnAbilities {

  use Mouse::Role;
  use Jikkoku;

  sub calc_success_ratio {
    my $self = shift;
    $self->skill->success_ratio;
  }

  sub calc_effect_time {
    my $self = shift;
    $self->skill->effect_time;
  }

}

1;

