package Jikkoku::Model::HistoryLog {

  use Jikkoku;
  use parent 'Jikkoku::Model::Base::TextData::Log::Integration';

  use constant {
    MAX       => 200,
    FILE_PATH => 'log_file/map_log2.cgi',
  };

}

1;
