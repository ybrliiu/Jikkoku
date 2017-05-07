package Jikkoku::Model::Role::TextData::Integration {

  use Mouse::Role;
  use Jikkoku;

  use Carp;
  use Option;
  use Module::Load;

  has 'textdata_list' => ( is => 'rw', isa => 'ArrayRef', required => 1 );

  with 'Jikkoku::Model::Role::Integration';

  sub open_data {
    my $class = shift;
    open(my $fh, '<', $class->file_path) or throw("file open error" . $class->file_path, $!);
    my @textdata_list = <$fh>;
    $fh->close;
    (
      data          => $class->_textdata_list_to_objects_data( \@textdata_list ),
      textdata_list => \@textdata_list,
    );
  }

  sub read {
    my $self = shift;
    my $fh = $self->fh;
    my @textdata_list = <$fh>;
    $self->data( $self->_textdata_list_to_objects_data(\@textdata_list) );
  }

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

  sub write {
    my $self = shift;
    $_->update_textdata for values %{ $self->data };
    $self->fh->print( @{ $self->_objects_data_to_textdata_list } );
  }

  sub _objects_data_to_textdata_list {
    my $self = shift;
    [ map { ${ $_->textdata } } values %{ $self->data } ];
  }

  sub abort {
    my $self = shift;
    $self->data( $self->_textdata_list_to_objects_data( $self->textdata_list ) );
  }

  sub save {
    my $self = shift;
    $_->update_textdata for values %{ $self->data };
    open(my $fh, '+<', $self->file_path);
    $fh->print( @{ $self->_objects_data_to_textdata_list } );
    $fh->close;
  }

  sub init {
    my $class = shift;
    open(my $fh, '+<', $class->file_path);
    $fh->print('');
    $fh->close;
  }

}

1;
