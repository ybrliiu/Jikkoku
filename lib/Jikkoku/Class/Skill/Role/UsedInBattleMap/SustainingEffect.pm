package Jikkoku::Class::Skill::Role::UsedInBattleMap::SustainingEffect {

  use Mouse::Role;
  use Jikkoku;

  with qw( Jikkoku::Class::Skill::Role::UsedInBattleMap );

  # method
  requires qw( effect_time );

}

1;

__END__
