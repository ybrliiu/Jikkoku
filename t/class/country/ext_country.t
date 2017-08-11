use Jikkoku;
use Test::More;
use Test::Exception;
use Test::Name::FromLine;

use Jikkoku::Model::Country;

my $CLASS = 'Jikkoku::Class::Country::ExtCountry';
use_ok $CLASS;

my $country_model = Jikkoku::Model::Country->new;
my $country = $country_model->get(1);

ok my $ext_country = Jikkoku::Class::Country::ExtCountry->new(country => $country);
diag $ext_country->name;
diag explain [ $ext_country->total_salary ];

done_testing;
