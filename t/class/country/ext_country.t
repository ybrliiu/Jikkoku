use Test::Jikkoku;
use Jikkoku::Model::Country;

my $CLASS = 'Jikkoku::Class::Country::ExtCountry';
use_ok $CLASS;

my $country_model = Jikkoku::Model::Country->new;
my $country = $country_model->get(1);

ok my $ext_country = Jikkoku::Class::Country::ExtCountry->new(country => $country);
is $ext_country->name, '美里西高校';
my ($money, $rice) = $ext_country->total_salary;
is $money, 146076;
is $rice, 130284;
is @{ $ext_country->members }, 6;
is @{ $ext_country->dominating_towns }, 12;
ok $ext_country->is_headquarters_exist;

subtest 'is_chara_has_position' => sub {
  ok $ext_country->is_chara_has_position( $ext_country->king->id );
  is $ext_country->position_name_of_chara( $ext_country->king ), '君主';
  my $position = $ext_country->position_of_chara_with_option( $ext_country->king )->get;
  is $position->id, 'king';
};

subtest 'number_of_chara_participate_available' => sub {
  ok my $num = $ext_country->number_of_chara_participate_available;
  is $num, 6;
  is @{ $ext_country->members }, 6;
  ok !$ext_country->can_participate;
};

done_testing;
