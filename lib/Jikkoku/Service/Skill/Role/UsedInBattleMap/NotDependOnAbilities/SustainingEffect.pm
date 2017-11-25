package Jikkoku::Service::Skill::Role::UsedInBattleMap::NotDependOnAbilities::SustainingEffect {

  use Mouse::Role;
  use Jikkoku;

  with qw( Jikkoku::Service::Skill::Role::UsedInBattleMap::NotDependOnAbilities );

  # require :
  # has 'skill' => (
  #   does => [
  #     'Jikkoku::Class::Skill::Skill',
  #     'Jikkoku::Class::Skill::Role::UsedInBattleMap::NotDependOnAbilities::SustainingEffect'
  #   ]
  # );

  sub calc_effect_time {
    my $self = shift;
    $self->skill->effect_time;
  }

}

1;

