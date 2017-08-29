package Jikkoku::Model::Role::TextData::List {

  use Mouse::Role;
  use Jikkoku;

  with qw(
    Jikkoku::Model::Role::TextData::FileHandler
    Jikkoku::Model::Role::List
  );

  sub _textdata_list_to_objects_data {
    my ($class, $textdata_list) = @_;
    [ map { $class->INFLATE_TO->new($_) } @$textdata_list ];
  }

  sub write : method {
    my $self = shift;
    $_->update_textdata for @{ $self->data };
    $self->fh->print( @{ $self->_objects_data_to_textdata_list } );
  }

  sub save {
    my $self = shift;
    $_->update_textdata for @{ $self->data };
    open(my $fh, '>', $self->file_path);
    $fh->print( @{ $self->_objects_data_to_textdata_list } );
    $fh->close;
  }

  sub _objects_data_to_textdata_list {
    my $self = shift;
    [ map { ${ $_->textdata } } @{ $self->data } ];
  }

}

1;

