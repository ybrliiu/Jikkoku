use v5.22;
use warnings;
use Data::Dumper;

open(my $fh, '<', 'f_town_data.cgi');
my @init_town_data = <$fh>;
$fh->close;

my $output = '';
for (@init_town_data) {
  chomp(my $line = $_);
  my @data = split /<>/, $line;
  my ($name, $country, $farmer, $farm, $business, $wall, $farm_max, $business_max,
    $wall_max, $loyalty, $x, $y, $price, $wall_power, $technology, $farmer_max) = @data;

  $output .= "
    '$name' => {
      name           => '$name',
      country_name   => '',
      x              => $x,
      y              => $y,
      loyalty        => $loyalty,
      farmer         => $farmer,
      farmer_max     => $farmer_max,
      farm           => $farm,
      farm_max       => $farm_max,
      business       => $business,
      business_max   => $business_max,
      technology     => $technology,
      technology_max => 500,
      wall           => $wall,
      wall_max       => $wall_max,
      wall_power     => $wall_power,
      wall_power_max => 1000,
      price          => 1.0,
    },";
}

say $output;

