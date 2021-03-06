use v5.24;
use warnings;
use lib './lib', './extlib', '../lib';

use Path::Tiny;
use PPI::Document;

replace_all();

sub replace_all {
  my @files = `find . -type f -exec grep -l "use lib './lib', './extlib'" {} \\;`;
  my $replace = "use lib './lib', './extlib'";
  my $to = "use lib './lib', './extlib', './extlib'";

  for my $file (@files) {
    chomp $file;
    my $path = path($file);
    my $sorce = $path->slurp;
    $sorce =~ s/$replace/$to/g;
    $path->spew($sorce);
  }

}

sub _replace_all {
  my @files = `find ./lib/Jikkoku -type f -exec grep -l "use v5.14;" {} \\;`;
  my $replace = <<"EOS";
  use v5.14;
  use warnings;
EOS
  chomp $replace;
  my $to = "  use Jikkoku;";

  for my $file (@files) {
    chomp $file;
    my $path = path($file);
    my $sorce = $path->slurp;
    $sorce =~ s/$replace/$to/g;
    $path->spew($sorce);
  }

}
