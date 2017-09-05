package Jikkoku::Model::Role::FileHandler::Storable::General {

  use Mouse::Role;
  use Jikkoku;
  use Storable ();

  sub _default_data { +{} }
  
  sub open_data {
    my $class = shift;
    open(my $fh, '<', $class->file_path(@_)) or throw("file open error", $!);
    my $data = Storable::fd_retrieve($fh) or throw("fd_retrieve error", $!);
    $fh->close;
    (data => $data);
  }

  sub abort {
    my $self = shift;
    open(my $fh, '<', $self->file_path) or throw("file open error", $!);
    $self->fh($fh);
    $self->read;
    $fh->close;
  }

  sub init {
    my $self = shift;
    Storable::nstore($self->_default_data, $self->file_path);
  }

  # init と統合
  sub make {
    my $class = shift;
    if ( -f $class->file_path(@_) ) {
      throw($class->file_path(@_) . 'is already exist.', 'file is already exist.');
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

