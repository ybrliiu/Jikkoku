package Jikkoku {

  use strict;
  use warnings;
  use feature ':5.14';

  our $VERSION = "0.78_00";

  sub import {
    $_->import for qw/strict warnings/;
    feature->import(':5.14');
  }

};

1;
