use v5.24;
use warnings;
use utf8;
use Set::Object;

print 'please input strings : ';
my @elements;
while ( chomp(my $tmp = <STDIN>) ) {
  last if $tmp eq '';
  push @elements, $tmp;
}
my $set = Set::Object->new(@elements);
say $_ for sort $set->elements;

