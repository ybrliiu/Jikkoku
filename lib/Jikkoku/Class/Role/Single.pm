package Jikkoku::Class::Role::Single {

  use Mouse::Role;
  use Jikkoku;

  # constants
  requires qw( FILE_PATH );

  sub file_path { $_[0]->FILE_PATH }

}

1;

