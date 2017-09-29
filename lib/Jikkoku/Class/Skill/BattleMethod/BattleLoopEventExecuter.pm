package Jikkoku::Class::Skill::BattleMethod::BattleLoopEventExecuter {

  use Mouse::Role;
  use Jikkoku;

  with qw(
    Jikkoku::Class::Skill::BattleMethod::BattleMethod
    Jikkoku::Class::Skill::Role::BattleLoopEventExecuter::DependOnAbilities
  );

  sub _build_items_of_depend_on_abilities { ['発動率'] }

}

1;

