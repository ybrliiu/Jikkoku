package Jikkoku::Model::Announce {

  use Jikkoku;
  use parent 'Jikkoku::Model::Base::TextData::List';

  use Jikkoku::Util qw( year_month_day validate_values );

  use constant {
    FILE_PATH => 'log_file/announce_log.txt',
    COLUMNS   => [qw( message time )],
    MAX       => 1000,
  };

  sub add {
    my ($self, $message) = @_;
    unshift @{ $self->{data} }, +{
      message => $message,
      time    => year_month_day(),
    };
    $self;
  }

  sub add_by_hash {
    my ($self, $args) = @_;
    validate_values $args => $self->COLUMNS;
    unshift @{ $self->{data} }, $args;
  }

}

1;
