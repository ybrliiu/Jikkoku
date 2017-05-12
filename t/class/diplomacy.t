use v5.14;
use warnings;
use Test::More;
use Test::Exception;
use Test::Name::FromLine;

my $CLASS = 'Jikkoku::Class::Diplomacy';
use_ok $CLASS;

ok( my $diplomacy = $CLASS->new({
  type               => $CLASS->CEASE_WAR,
  request_country_id => 2,
  receive_country_id => 1,
}) );

ok $diplomacy->DOES('Jikkoku::Class::Role::Diplomacy');

require Jikkoku::Model::Country;
my $country_model = Jikkoku::Model::Country->new;
is $diplomacy->show_status(2, $country_model), '(本当は)平和主義共和国へ停戦を要請中';
is $diplomacy->show_status(1, $country_model), '<span style="color: red">【外交要請】</span>梁山泊から停戦要請が来ています';

done_testing;
