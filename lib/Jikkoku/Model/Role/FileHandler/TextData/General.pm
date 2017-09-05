package Jikkoku::Model::Role::FileHandler::TextData::General {

  use Mouse::Role;
  use Jikkoku;

  with 'Jikkoku::Model::Role::FileHandler::TextData::TextData';

  sub _textdata_list_to_objects_data {
    my ($class, $textdata_list) = @_;
    my @objects = map { $class->INFLATE_TO->new($_) } @$textdata_list;
    $class->to_hash(\@objects);
  }

  sub to_hash {
    my ($class, $objects) = @_;
    my $primary_attribute = $class->PRIMARY_ATTRIBUTE;
    +{ map { $_->$primary_attribute => $_ } @$objects };
  }

  sub write : method {
    my $self = shift;
    $_->update_textdata for values %{ $self->data };
    $self->fh->print( @{ $self->_objects_data_to_textdata_list } );
  }

  sub save {
    my $self = shift;
    $_->update_textdata for values %{ $self->data };
    open(my $fh, '>', $self->file_path);
    $fh->print( @{ $self->_objects_data_to_textdata_list } );
    $fh->close;
  }

  sub _objects_data_to_textdata_list {
    my $self = shift;
    [ map { ${ $_->textdata } } values %{ $self->data } ];
  }

}

1;
