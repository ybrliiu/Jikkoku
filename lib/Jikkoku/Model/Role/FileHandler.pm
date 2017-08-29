package Jikkoku::Model::Role::FileHandler {
  
  use Mouse::Role;
  use Jikkoku;

  with 'Jikkoku::Role::FileHandler';

  requires qw( FILE_PATH open_data init );

  sub file_path { shift->FILE_PATH }

  around BUILDARGS => sub {
    my ($orig, $class) = @_;
    $class->$orig( $class->open_data );
  };

}

1;

