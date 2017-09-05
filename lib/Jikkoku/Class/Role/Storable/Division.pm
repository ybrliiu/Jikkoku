package Jikkoku::Class::Role::Storable::Division {

  use Mouse::Role;
  use Jikkoku;
  use Option;
  use Carp;
  use Storable ();

  with qw(
    Jikkoku::Role::FileHandler
    Jikkoku::Role::FileHandler::Division
  );
  
  around BUILDARGS => sub {
    my ($orig, $class) = (shift, shift);
    if (ref $_[0] eq 'HASH') {
      my $args = shift;
      $class->$orig($args);
    } else {
      my $id = shift;
      open(my $fh, '<', $class->file_path($id)) or throw("file open error", $!);
      my $data = Storable::fd_retrieve($fh) or throw("fd_retrieve error", $!);
      $fh->close;
      my %data = %$data;
      \%data;
    }
  };

  sub make {
    my $self = shift;
    my $file_path = $self->file_path;
    if ( -f $file_path ) {
      throw("$file_path is already exist.", 'file is already exist.');
    } else {
      Storable::nstore($self, $file_path);
    }
  }

  sub remove {
    my $self = shift;
    unlink $self->file_path or throw("remove file failed.", $!);
  }

  sub abort {
    my $self = shift;
    open(my $fh, '<', $self->file_path) or throw("file open error", $!);
    $self->fh($fh);
    $self->read;
    $fh->close;
  }

  sub read {
    my $self = shift;
    my $data = Storable::fd_retrieve($self->fh) or throw("fd_retrieve error", $!);
    for my $key (keys %$data) {
      $self->{$key} = $data->{$key};
    }
  }

  sub write {
    my $self = shift;
    Storable::nstore_fd($self, $self->fh) or throw("nstore_fd error", $!);
  }

}

1;

=encoding utf8

* new
- 新規ファイル作成時
my $chara = ClassName->new({args});
$chara->make;
- ファイル読み込み
my $chara = ClassName->new("id");

=cut
