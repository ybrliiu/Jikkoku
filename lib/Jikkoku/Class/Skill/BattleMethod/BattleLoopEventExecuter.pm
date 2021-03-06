package Jikkoku::Class::Skill::BattleMethod::BattleLoopEventExecuter {

  use Mouse::Role;
  use Jikkoku;

  with qw(
    Jikkoku::Class::Skill::BattleMethod::BattleMethod
    Jikkoku::Class::Skill::Role::BattleLoopEventExecuter::DependOnAbilities
  );

  around _build_items_of_depend_on_abilities => sub { ['発動率'] };

}

1;

