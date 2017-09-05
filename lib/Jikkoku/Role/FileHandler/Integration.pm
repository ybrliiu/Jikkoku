package Jikkoku::Role::FileHandler::Integration {

  use Mouse::Role;
  use Jikkoku;

  requires qw( FILE_PATH );

  sub file_path { shift->FILE_PATH }

}

1;

