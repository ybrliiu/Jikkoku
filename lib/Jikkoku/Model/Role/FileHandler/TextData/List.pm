package Jikkoku::Model::Role::FileHandler::TextData::List {

  use Mouse::Role;
  use Jikkoku;

  with 'Jikkoku::Model::Role::FileHandler::TextData::TextData';

  sub _textdata_list_to_objects_data {
    my ($class, $textdata_list) = @_;
    [ map { $class->INFLATE_TO->new($_) } @$textdata_list ];
  }

  sub write : method {
    my $self = shift;
    $_->update_textdata for @{ $self->data };
    my @data = @{ $self->_objects_data_to_textdata_list };
    splice @data, $self->MAX;
    $self->fh->print(@data);
  }

  sub save {
    my $self = shift;
    open(my $fh, '>', $self->file_path);
    $self->fh($fh);
    $self->write;
    $fh->close;
    $self->fh(undef);
    1;
  }

  sub _objects_data_to_textdata_list {
    my $self = shift;
    [ map { ${ $_->textdata } } @{ $self->data } ];
  }

}

1;

