package Jikkoku::Model::Role::Logger::Single {

  use Mouse::Role;
  use Jikkoku;

  requires qw( FILE_PATH );

  with 'Jikkoku::Role::Logger';

  sub file_path { $_[0]->FILE_PATH }

}

1;

