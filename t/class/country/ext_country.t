use Jikkoku;
use Test::More;
use Test::Exception;
use Test::Name::FromLine;

use Jikkoku::Model::Country;

my $CLASS = 'Jikkoku::Class::Country::ExtCountry';
use_ok $CLASS;

my $country_model = Jikkoku::Model::Country->new;
my $country = $country_model->get(2);

ok my $ext_country = Jikkoku::Class::Country::ExtCountry->new(country => $country);
is $ext_country->name, '梁山泊';
my ($money, $rice) = $ext_country->total_salary;
is $money, 3600;
is $rice, 3150;
is @{ $ext_country->members }, 4;
is @{ $ext_country->dominating_towns }, 1;
ok $ext_country->is_headquarters_exist;

subtest 'is_chara_has_position' => sub {
  ok $ext_country->is_chara_has_position( $ext_country->king->id );
  is $ext_country->position_name_of_chara( $ext_country->king ), '君主';
  my $position = $ext_country->position_of_chara_with_option( $ext_country->king )->get;
  is $position->id, 'king';
};

subtest 'number_of_chara_participate_available' => sub {
  ok my $num = $ext_country->number_of_chara_participate_available;
  is $num, 5;
  is @{ $ext_country->members }, 4;
  ok $ext_country->can_participate;
};

done_testing;
