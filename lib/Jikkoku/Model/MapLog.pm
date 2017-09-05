package Jikkoku::Model::MapLog {

  use Mouse;
  use Jikkoku;

  with 'Jikkoku::Model::Role::Logger::Single';

  use constant {
    MAX       => 200,
    FILE_PATH => 'log_file/map_log.cgi',
  };

  __PACKAGE__->meta->make_immutable;

}

1;
