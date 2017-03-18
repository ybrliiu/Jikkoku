package Jikkoku::Class::Role::TextData::Generic {

  use Mouse::Role;
  use Jikkoku;

  requires qw( output inflate_textdata );

  around BUILDARGS => sub {
    my ($orig, $class) = (shift, shift);
    my $args = ref $_[0] eq 'HASH' ? $_[0] : +{@_};
    $args->{data} = $class->inflate_textdata($args) if exists $args->{textdata};
    $class->$orig($args);
  };

}

1;

