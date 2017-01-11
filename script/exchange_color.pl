use v5.14;
use warnings;
use Path::Tiny;

our (@ELE_C, @ELE_BG, @ELE_RGBA);
require 'tmp/color.pl';

output('country_color', \@ELE_C);
output('country_background_color', \@ELE_BG);
output('country_background_color_rgba', \@ELE_RGBA);

sub output {
  my ($name, $array) = @_;

  my $str = "{\n  $name => [\n";
  for (@$array) {
    $str .= qq{    '} . lc $_ . qq{',\n};
  }
  $str .= "  ],\n}\n";

  say $str;

  my $file = path("../etc/$name.conf");
  $file->touch;
  $file->spew( $str );
}
