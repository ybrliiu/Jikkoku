package Jikkoku::Class::Role::TextData::Single {

  use Mouse::Role;
  use Jikkoku;

  with qw(
    Jikkoku::Class::Role::TextData::FileHandler
    Jikkoku::Class::Role::Single
  );

  around _buildargs_textdata => sub {
    my ($orig, $class) = @_;
    open(my $fh, '<', $class->file_path) or throw("file open error " . $class->file_path, $!);
    my @textdata = <$fh>;
    $fh->close;
    $class->$orig( $textdata[0] );
  };

}

1;

