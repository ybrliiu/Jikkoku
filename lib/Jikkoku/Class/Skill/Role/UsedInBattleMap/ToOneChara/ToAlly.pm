package Jikkoku::Class::Skill::Role::UsedInBattleMap::ToOneChara::ToAlly {

  use Mouse::Role;
  use Jikkoku;
  use Jikkoku::Util;

  with qw(
    Jikkoku::Class::Skill::Role::ToAlly
    Jikkoku::Class::Skill::Role::UsedInBattleMap::ToOneChara
  );

}

1;

__END__
