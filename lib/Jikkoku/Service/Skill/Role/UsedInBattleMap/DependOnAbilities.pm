package Jikkoku::Service::Skill::Role::UsedInBattleMap::DependOnAbilities {

  use Mouse::Role;
  use Jikkoku;

  with qw( Jikkoku::Service::Skill::Role::UsedInBattleMap );

  sub calc_success_ratio {
    my $self = shift;
    $self->skill->calc_success_ratio;
  }

}

1;
