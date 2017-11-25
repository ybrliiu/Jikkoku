package Jikkoku::Service::Skill::Role::UsedInBattleMap::NotDependOnAbilities {

  use Mouse::Role;
  use Jikkoku;

  with qw( Jikkoku::Service::Skill::Role::UsedInBattleMap );

  sub calc_success_ratio {
    my $self = shift;
    $self->skill->success_ratio;
  }

}

1;

