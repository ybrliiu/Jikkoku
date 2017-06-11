package Jikkoku::Class::Skill::Role::UsedInBattleMap::ToOneChara::ToEnemy {

  use Mouse::Role;
  use Jikkoku;
  use Jikkoku::Util;

  with qw(
    Jikkoku::Class::Skill::Role::ToEnemy
    Jikkoku::Class::Skill::Role::UsedInBattleMap::ToOneChara
  );

}

1;

__END__

