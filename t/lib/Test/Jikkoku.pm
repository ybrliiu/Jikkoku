package Test::Jikkoku {

  use Jikkoku;
  use parent qw( Jikkoku );
  use Module::Load qw( autoload_remote load );

  sub import {
    my $class = shift;
    my $pkg = caller;
    $class->SUPER::import;
    my @load_remote = qw(
      Test::More
      Test::Exception
      Test::Name::FromLine
    );
    autoload_remote($pkg, $_) for @load_remote;
    load Test::Jikkoku::Container;
  }

}

1;
