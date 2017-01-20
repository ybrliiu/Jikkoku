use v5.14;
use warnings;
use Test::More;
use Test::Exception;
use Test::Name::FromLine;

my $CLASS = 'Jikkoku::Class::Diplomacy::DeclareWar';
use_ok $CLASS;

require Jikkoku::Model::Country;
my $country_model = Jikkoku::Model::Country->new;
require Jikkoku::Model::GameDate;
my $now_game_date = Jikkoku::Model::GameDate->new->get;

subtest not_accpted => sub {
  require Jikkoku::Model::GameDate;
  my $start_game_date = Jikkoku::Class::GameDate->new({
    elapsed_year => 10,
    month        => 3,
  });

  ok(
    my $declare_war = Jikkoku::Class::Diplomacy::DeclareWar->new({
      request_country_id => 0,
      receive_country_id => 1,
      now_game_date      => $now_game_date,
      start_game_date    => $start_game_date,
      message            => 'よろしく',
    })
  );

  is $declare_war->start_game_date->year, 885;
  is $declare_war->show_status( 0, $country_model ), '(本当は)平和主義共和国へ短縮布告を要請中 (885年3月より開戦)';
};

subtest accepted => sub {
  my $start_game_date = Jikkoku::Class::GameDate->new({
    elapsed_year => 1000,
    month        => 12,
  });

  ok (
    my $declare_war = Jikkoku::Class::Diplomacy::DeclareWar->new({
      request_country_id => 0,
      receive_country_id => 1,
      now_game_date      => $now_game_date,
      start_game_date    => $start_game_date,
    })
  );

  is $declare_war->show_status(0, $country_model), '1875年12月から(本当は)平和主義共和国と戦争';
};

done_testing;
