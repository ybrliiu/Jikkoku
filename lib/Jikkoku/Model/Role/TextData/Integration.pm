package Jikkoku::Model::Role::TextData::Integration {

  use Jikkoku;
  use Option;
  use Carp qw( croak );
  use List::Util qw( max );
  use Jikkoku::Util;

  requires qw( FILE_PATH CLASS );

  has 'data'          => ( is => 'rw', isa => 'HashRef', default => sub { +{} } );
  has 'textdata_list' => ( is => 'ro', isa => 'ArrayRef[ScalarRef]', default => sub { [] } );

  sub file_path {
    my $class = shift;
    $class->FILE_PATH;
  }

  sub BUILD {
    my $self = shift;
    $self->textdata_list( Jikkoku::Util::open_data( $self->file_path ) );
    $self->data( $self->textdata_list_to_objects_data );
  }

  sub _new {
    my ($self) = @_;
    $self->{_textdata_list} = open_data( $self->FILE_PATH );
    $self->{data}           = $self->_textdata_list_to_objects_data;
  }

  sub new {
    my ($class) = @_;
    my $self = bless {
      _textdata_list => [],
      data           => {},
    }, $class;
    $self->_new;
    $self;
  }

  sub abort {
    my $self = shift;
    $self->{data} = $self->_textdata_list_to_objects_data;
  }

  sub delete {
    my ($self, $id) = @_;
    delete $self->{data}{$id};
  }

  sub get {
    my ($self, $id) = @_;
    my $object = $self->{data}{$id};
    ref $object eq $self->CLASS ? $object : Carp::croak " データが見つかりませんでした ($id) ";
  }

  sub opt_get {
    my ($self, $id) = @_;
    Option->new( $self->{data}{$id} );
  }

  sub get_all {
    my ($self) = @_;
    [ values %{ $self->{data} } ];
  }

  sub get_all_to_hash {
    my ($self) = @_;
    $self->{data};
  }

  sub init {
    my ($class) = @_;
    save_data( $class->FILE_PATH, [] );
  }

  sub refetch {
    my ($self) = @_;
    $self->_new;
  }

  sub save {
    my ($self) = @_;
    my $textdata_list = $self->_objects_data_to_textdata_list;
    save_data( $self->FILE_PATH, $textdata_list );
  }

  sub _objects_data_to_textdata_list {
    my ($self) = @_;
    [ map { ${ $_->output } } values %{ $self->{data} } ];
  }

  sub _textdata_list_to_objects_data {
    my ($self) = @_;
    my $objects = [ map { $self->CLASS->new($_) } @{ $self->{_textdata_list} } ];
    $self->to_hash( $objects );
  }

  sub to_hash {
    my ($class, $list) = @_;
    my $primary_key = $class->CLASS->PRIMARY_KEY;
    +{ map { $_->$primary_key => $_ } @$list };
  }

}

1;
