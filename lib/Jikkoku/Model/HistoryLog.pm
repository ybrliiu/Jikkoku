package Jikkoku::Model::HistoryLog {

  use Mouse;
  use Jikkoku;

  with 'Jikkoku::Model::Role::Logger::Single';

  use constant {
    MAX       => 200,
    FILE_PATH => 'log_file/map_log2.cgi',
  };

  __PACKAGE__->meta->make_immutable;

}

1;
