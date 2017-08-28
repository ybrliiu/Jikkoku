package Jikkoku::Class::Role::TextData::Division {

  use Mouse::Role;
  use Jikkoku;
  use Carp;

  with qw(
    Jikkoku::Class::Role::TextData::FileHandler
    Jikkoku::Class::Role::Division
  );

  # $textdata -> $id
  around _buildargs_textdata => sub {
    my ($orig, $class, $id) = @_;
    open(my $fh, '<', $class->file_path($id)) or throw("file open error" . $class->file_path($id), $!);
    my @textdata = <$fh>;
    $fh->close;
    $class->$orig( $textdata[0] );
  };

}

1;

