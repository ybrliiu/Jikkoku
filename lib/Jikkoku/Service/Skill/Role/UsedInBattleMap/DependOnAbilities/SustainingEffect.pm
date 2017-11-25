package Jikkoku::Service::Skill::Role::UsedInBattleMap::DependOnAbilities::SustainingEffect {

  use Mouse::Role;
  use Jikkoku;

  with qw( Jikkoku::Service::Skill::Role::UsedInBattleMap::DependOnAbilities );

  # require :
  # has 'skill' => (
  #   does => [
  #     'Jikkoku::Class::Skill::Skill',
  #     'Jikkoku::Class::Skill::Role::UsedInBattleMap::DependOnAbilities::SustainingEffect'
  #   ]
  # );

  sub calc_effect_time {
    my $self = shift;
    my ($min_effect_time, $max_effect_time) = $self->skill->effect_time;
    $min_effect_time + int( rand $max_effect_time - $min_effect_time );
  }

}

1;
