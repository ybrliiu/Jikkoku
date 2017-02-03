package Jikkoku::Class::Role::TextData::Division {

  use Mouse::Role;
  use Jikkoku;
  use Carp;
  use Jikkoku::Util qw( is_test TEST_DIR _open_data );

  requires 'DIR_PATH';

  with qw(
    Jikkoku::Class::Role::TextData
    Jikkoku::Role::FileHandler
  );

  sub file_path {
    my ($self, $id) = @_;
    if (ref $self) {
      $self->DIR_PATH . $self->id . '.cgi';
    } else {
      my $class = $self;
      $class->DIR_PATH . "$id.cgi";
    }
  }

  # $textdata -> $id
  around _buildargs_textdata => sub {
    my ($orig, $class, $id) = @_;
    my $textdata = _open_data( $class->file_path($id) )->[0];
    $class->$orig($textdata);
  };

  sub read {
    my $self = shift;
    my $fh = $self->fh;
    my $textdata = <$fh>;
    my $hash = $self->textdata_to_hash($textdata);
    $self->set_hash_value($hash);
  }
  
  sub write {
    my $self = shift;
    $self->update_textdata;
    $self->fh->print( ${ $self->textdata } . "\n" );
  }

}

1;

