package Jikkoku::Model::Role::TextData::Integration {

  use Jikkoku;
  use Option;
  use Carp qw( croak );
  use List::Util qw( max );
  use Jikkoku::Util;

  requires qw( FILE_PATH CLASS );

  has 'fh'            => ( is => 'rw', isa => 'FileHandle' );
  has 'data'          => ( is => 'rw', isa => 'HashRef', default => sub { +{} } );
  has 'textdata_list' => ( is => 'ro', isa => 'ArrayRef[ScalarRef]', default => sub { [] } );

  sub file_path {
    my $class = shift;
    $class->FILE_PATH;
  }

  sub BUILD {
    my $self = shift;
    $self->textdata_list( Jikkoku::Util::open_data( $self->file_path ) );
    $self->data( $self->_textdata_list_to_objects_data );
  }

  sub delete {
    my ($self, $id) = @_;
    my $data = $self->data;
    delete $data->{$id};
  }

  sub get {
    my ($self, $id) = @_;
    Option->new( $self->data->{$id} );
  }

  sub get_all {
    my ($self) = @_;
    [ values %{ $self->data } ];
  }

  sub get_all_to_hash {
    my ($self) = @_;
    $self->data;
  }

  sub init {
    my $class = shift;
    save_data( $class->FILE_PATH, [] );
  }

  sub refetch {
    my ($self) = @_;
    $self->BUILD;
  }

  sub save {
    my ($self) = @_;
    my $textdata_list = $self->_objects_data_to_textdata_list;
    save_data( $self->FILE_PATH, $textdata_list );
  }

  sub _objects_data_to_textdata_list {
    my ($self) = @_;
    [ map { ${ $_->output } } values %{ $self->data } ];
  }

  sub _textdata_list_to_objects_data {
    my ($self) = @_;
    my $objects = [ map { $self->CLASS->new($_) } @{ $self->textdata_list } ];
    $self->to_hash( $objects );
  }

  sub to_hash {
    my ($class, $list) = @_;
    my $primary_key = $class->CLASS->PRIMARY_KEY;
    +{ map { $_->$primary_key => $_ } @$list };
  }

}

1;
