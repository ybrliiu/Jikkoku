package Jikkoku::Model::Role::Storable {

  use Mouse::Role;
  use Jikkoku;
  use Option;
  use Storable ();

  requires qw( CLASS FILE_PATH );

  # example
  # has 'data' => ( is => 'rw', isa => 'HashRef[' . CLASS . ']', builder => _default_data );
  requires 'data';

  with 'Jikkoku::Role::FileHandler';

  sub file_path { shift->FILE_PATH }

  sub _default_data { +{} }
  
  sub BUILD {
    my $self = shift;
    open(my $fh, '<', $self->file_path) or throw("file open error", $!);
    $self->fh($fh);
    $self->read;
    $fh->close;
    $self->{fh} = undef;
  }

  sub abort {
    my $self = shift;
    open(my $fh, '<', $self->file_path) or throw("file open error", $!);
    $self->fh($fh);
    $self->read;
    $fh->close;
  }

  sub delete {
    my ($self, $key) = @_;
    delete $self->data->{$key};
  }

  sub get {
    my ($self, $key) = @_;
    Option->new( $self->data->{$key} );
  }

  sub get_all {
    my $self = shift;
    [ values %{$self->data} ];
  }

  sub init {
    my $self = shift;
    Storable::nstore($self->_default_data, $self->file_path);
  }

  sub make {
    my $class = shift;
    if ( -f $class->file_path ) {
      throw($class->file_path . 'is already exist.', 'file is already exist.');
    } else {
      Storable::nstore($class->_default_data, $class->file_path(@_));
    }
  }

  sub read {
    my $self = shift;
    my $data = Storable::fd_retrieve($self->fh) or throw("fd_retrieve error", $!);
    $self->data($data);
  }

  sub write {
    my $self = shift;
    Storable::nstore_fd($self->data, $self->fh) or throw("nstore_fd error", $!);
  }

}

1;

