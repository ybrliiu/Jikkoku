package Jikkoku::Model::HistoryLog {

  use v5.14;
  use warnings;
  use parent 'Jikkoku::Model::Base::TextData::Log::Integration';

  use constant {
    MAX       => 200,
    FILE_PATH => 'log_file/map_log2.cgi',
  };

}

1;
