package Jikkoku {

  use strict;
  use warnings;
  use feature ':5.14';

  our $VERSION = "0.79_00";

  sub import {
    my $class = shift;
    $_->import for qw( strict warnings );
    feature->import(':5.14');
  }

};

1;
