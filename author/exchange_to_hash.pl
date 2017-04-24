# log_file/bou.cgi (旧防具データ) を変換

use v5.22;
use warnings;
use Data::Dumper;
open(my $fh, "<", "bou.cgi");
my @guard_list = <$fh>;
$fh->close;
my $output;
for (@guard_list) {
  my $data = $_;
  chomp $data;
  my @data = split /<>/, $data;
  my ($name, $price, $power, $attr, $attr_power, $class) = @data[0 .. 5];
  $output .= "
    '$name' => {
      name  => '$name',
      price => $price,
      power => $power, 
      class => $class,
      skill => [],
    },";
}
say $output;

