package Jikkoku::Model::Chara::AutoModeList {

  use Mouse;
  use Jikkoku;

  use constant {
    FILE_PATH         => 'log_file/auto_list.cgi',
    INFLATE_TO        => '',
    PRIMARY_ATTRIBUTE => '',
  };

  with 'Jikkoku::Model::Role::TextData::General::Integration';

  sub add {
    my ($self, $id) = @_;
    Carp::croak 'Too few arguments (required: $id)' if @_ < 2;
    $self->data->{$id} = $id;
  }

  around get_all => sub {
    my ($orig, $self) = @_;
    [ sort values %{ $self->data } ];
  };

  around _textdata_list_to_objects_data => sub {
    my ($orig, $class, $textdata_list) = @_;
    +{ map { $_ => $_ } @$textdata_list };
  };

  around _objects_data_to_textdata_list => sub {
    my ($orig, $self) = @_;
    [ map { "$_\n" } sort values %{ $self->data } ];
  };

  around save => sub {
    my ($orig, $self) = @_;
    # '+<' でないと空データを書き込めないので、 '>'
    open(my $fh, '>', $self->file_path)
      or Jikkoku::Role::FileHandlerException->throw("file open error", $!);
    $fh->print( @{ $self->_objects_data_to_textdata_list } );
    $fh->close;
  };

  around write => sub {
    my ($orig, $self) = @_;
    $self->fh->print( @{ $self->_objects_data_to_textdata_list } );
  };

  __PACKAGE__->meta->make_immutable;

}

1;
