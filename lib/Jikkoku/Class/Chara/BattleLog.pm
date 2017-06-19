package Jikkoku::Class::Chara::BattleLog {

  use Mouse;
  use Jikkoku;

  with 'Jikkoku::Role::Logger';

  __PACKAGE__->meta->make_immutable;

}

1;

