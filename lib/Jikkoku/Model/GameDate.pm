package Jikkoku::Model::GameDate {

  use Jikkoku;
  use parent 'Jikkoku::Model::Base::TextData::Single';
  use Jikkoku::Class::GameDate;

  use constant {
    CLASS     => 'Jikkoku::Class::GameDate',
    FILE_PATH => 'log_file/date_count.cgi',
  };

  sub init {
    my ($self, $start_time) = @_;
    $self->{data}->init( $start_time );
  }

}

1;
