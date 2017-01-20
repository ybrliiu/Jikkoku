use v5.14;
use warnings;
use Test::More;
use Test::Exception;
use Test::Name::FromLine;

use Jikkoku::Model::GameDate;
use Jikkoku::Model::Country;

my ($country_id, $country_id2) = (2, 1);
my $country_model = Jikkoku::Model::Country->new;
my $now_game_date = Jikkoku::Model::GameDate->new->get;

my $CLASS = 'Jikkoku::Model::Diplomacy';
use_ok $CLASS;

ok( my $diplomacy_model = $CLASS->new );
ok( my $diplomacy_list  = $diplomacy_model->get_by_country_id( $country_id ) );
is @$diplomacy_list, 4;

ok $diplomacy_model->add({
  type               => $CLASS->CLASS->CESSION_OR_ACCEPT_TERRITORY,
  request_country_id => $country_id,
  receive_country_id => $country_id2,
});

subtest 'already_sended' => sub {
  my $param = +{
    type               => $CLASS->CLASS->ALLOW_PASSAGE,
    request_country_id => $country_id2,
    receive_country_id => $country_id,
    now_game_date   => $now_game_date,
    start_game_date => Jikkoku::Class::GameDate->new({
      elapsed_year => 900,
      month        => 8,
    }),
    message => 'hoge',
  };
  ok $diplomacy_model->add( $param );
  dies_ok { $diplomacy_model->add( $param ) };
};

subtest 'already_sended_by_receiver' => sub {
  my $param = +{
    type               => $CLASS->CLASS->ALLOW_PASSAGE,
    request_country_id => $country_id,
    receive_country_id => $country_id2,
    now_game_date      => $now_game_date,
    start_game_date    => Jikkoku::Class::GameDate->new({
      elapsed_year => 900,
      month        => 2,
    }),
  };
  dies_ok { $diplomacy_model->add( $param ) };
};

subtest 'declare_war already_sended' => sub {
  my $param = +{
    type               => $CLASS->CLASS->DECLARE_WAR,
    request_country_id => $country_id2,
    receive_country_id => $country_id,
    now_game_date   => $now_game_date,
    start_game_date => Jikkoku::Class::GameDate->new({
      elapsed_year => 900,
      month        => 4,
    }),
  };
  ok $diplomacy_model->add( $param );
  dies_ok { $diplomacy_model->add( $param ) };
};

subtest 'declare_war already_sended_by_receiver' => sub {
  my $param = +{
    type               => $CLASS->CLASS->DECLARE_WAR,
    request_country_id => $country_id,
    receive_country_id => $country_id2,
    now_game_date      => $now_game_date,
    start_game_date    => Jikkoku::Class::GameDate->new({
      elapsed_year => 900,
      month        => 6,
    }),
  };
  dies_ok { $diplomacy_model->add( $param ) };
};

ok( $diplomacy_list = $diplomacy_model->get_by_country_id( $country_id ) );
is @$diplomacy_list, 7;
ok grep $_->show_status($country_id, $country_model) =~ /\(本当は\)平和主義共和国/, @$diplomacy_list;

ok $diplomacy_model->delete_by_country_id( $country_id2 );
ok( $diplomacy_list = $diplomacy_model->get_by_country_id( $country_id ) );
is @$diplomacy_list, 4;
ok not grep $_->show_status($country_id, $country_model) =~ /\(本当は\)平和主義共和国/, @$diplomacy_list;

done_testing;
