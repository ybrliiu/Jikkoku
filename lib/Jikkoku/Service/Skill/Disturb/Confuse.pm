# 混乱スキル処理

package Jikkoku::Service::Skill::Disturb::Confuse {

  use Mouse;
  use Jikkoku;

  with qw(
    Jikkoku::Service::Skill::Role::UsedInBattleMap::GiveState
    Jikkoku::Service::Skill::Role::UsedInBattleMap::Disturb
    Jikkoku::Service::Skill::Role::UsedInBattleMap::ToOneChara::ToEnemy
  );

  __PACKAGE__->meta->make_immutable;

}

1;
