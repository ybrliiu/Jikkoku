package Jikkoku::Model::Announce {

  use Mouse;
  use Jikkoku;
  use Jikkoku::Util qw( validate_values );

  use constant {
    MAX        => 1000,
    FILE_PATH  => 'log_file/announce_log.txt',
    INFLATE_TO => 'Jikkoku::Class::Announce',
  };

  with 'Jikkoku::Model::Role::TextData::List';

  sub add_by_message {
    my ($self, $message) = @_;
    Carp::croak 'few arguments($message)' if @_ < 2;
    $self->add({message => $message});
  }
  
  __PACKAGE__->prepare;

  __PACKAGE__->meta->make_immutable;

}

1;
