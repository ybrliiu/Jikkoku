package Jikkoku::Class::Chara::CommandLog {

  use Mouse;
  use Jikkoku;
  
  use constant {
    MAX      => 600,
    DIR_PATH => 'charalog/log/',
  };

  with 'Jikkoku::Class::Role::Logger';

  __PACKAGE__->meta->make_immutable;

}

1;

