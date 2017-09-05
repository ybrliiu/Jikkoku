package Jikkoku::Model::Role::FileHandler::TextData::TextData {

  use Mouse::Role;
  use Jikkoku;

  has 'textdata_list' => ( is => 'rw', isa => 'ArrayRef', required => 1 );

  sub extract_textdata {
    my $fh = shift;
    [ grep { $_ ne '' } map { $_ =~ s/(\n|\r|\r\n)//gr } <$fh> ];
  }

  sub open_data {
    my $class = shift;
    open(my $fh, '<', $class->file_path(@_))
      or Jikkoku::Role::FileHandlerException->throw("file open error" . $class->file_path(@_), $!);
    my $textdata_list = extract_textdata($fh);
    $fh->close;
    (
      data          => $class->_textdata_list_to_objects_data( $textdata_list ),
      textdata_list => $textdata_list,
    );
  }

  sub read : method {
    my $self = shift;
    my $fh = $self->fh;
    my $textdata_list = extract_textdata($fh);
    $self->data( $self->_textdata_list_to_objects_data( $textdata_list) );
  }

  sub abort {
    my $self = shift;
    $self->data( $self->_textdata_list_to_objects_data( $self->textdata_list ) );
  }

  sub init {
    my $class = shift;
    open(my $fh, '>', $class->file_path(@_))
      or Jikkoku::Role::FileHandlerException->throw("file open error", $!);
    $fh->print();
    $fh->close;
  }

}

1;
