package Jikkoku::Service::Skill::Role::UsedInBattleMap::NotDependOnAbilities {

  use Mouse::Role;
  use Jikkoku;

  around calc_success_ratio => sub {
    my ($orig, $self) = @_;
    $self->skill->success_ratio;
  };

  sub calc_effect_time {
    my $self = shift;
    $self->skill->effect_time;
  }

}

1;

