package Jikkoku::Model::Role::TextData::Integration {

  use Mouse::Role;
  use Jikkoku;

  with qw(
    Jikkoku::Role::FileHandler::TextData
    Jikkoku::Model::Role::Integration
  );

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

}

1;
