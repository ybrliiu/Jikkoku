package Jikkoku::Role::Singleton {

  use Mouse::Role;
  use Jikkoku;

  sub instance {
    my $class = shift;
    state $instances = {};
    if (exists $instances->{$class}) {
      $instances->{$class};
    } else {
      my $args = ref $_[0] eq 'HASH' ? $_[0] : +{@_};
      $instances->{$class} = $class->new($args);
    }
  }

}

1;

