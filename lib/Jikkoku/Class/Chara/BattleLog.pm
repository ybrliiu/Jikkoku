package Jikkoku::Class::Chara::BattleLog {

  use Mouse;
  use Jikkoku;
  
  use constant {
    MAX      => 600,
    DIR_PATH => 'charalog/blog/',
  };

  with 'Jikkoku::Class::Role::Logger::Division';

  __PACKAGE__->meta->make_immutable;

}

1;

