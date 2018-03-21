use Test::Jikkoku;

my $CLASS = 'Jikkoku::Class::Diplomacy';
use_ok $CLASS;

ok( my $diplomacy = $CLASS->new({
  type               => $CLASS->CEASE_WAR,
  request_country_id => 2,
  receive_country_id => 1,
}) );

require Jikkoku::Model::Country;
my $country_model = Jikkoku::Model::Country->new;
is $diplomacy->show_status(2, $country_model), '美里西高校へ停戦を要請中';
is $diplomacy->show_status(1, $country_model), '<span style="color: red">【外交要請】</span>桜Trickから停戦要請が来ています';

done_testing;
