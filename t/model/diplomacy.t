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
is @$diplomacy_list, 1;

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

my $declare_war_params;
subtest 'declare_war already_sended_by_receiver' => sub {
  $declare_war_params = +{
    type               => $CLASS->CLASS->DECLARE_WAR,
    request_country_id => $country_id,
    receive_country_id => $country_id2,
    now_game_date      => $now_game_date,
    start_game_date    => Jikkoku::Class::GameDate->new({
      elapsed_year => 900,
      month        => 6,
    }),
  };
  dies_ok { $diplomacy_model->add( $declare_war_params ) };
};

ok( $diplomacy_list = $diplomacy_model->get_by_country_id( $country_id ) );
is @$diplomacy_list, 4;
ok grep $_->show_status($country_id, $country_model) =~ /\(本当は\)平和主義共和国/, @$diplomacy_list;

ok $diplomacy_model->delete_by_country_id( $country_id2 );
ok( $diplomacy_list = $diplomacy_model->get_by_country_id( $country_id ) );
is @$diplomacy_list, 1;
ok not grep $_->show_status($country_id, $country_model) =~ /\(本当は\)平和主義共和国/, @$diplomacy_list;

# 攻撃できるかどうかのテスト
subtest 'can_attack, can_passage' => sub {

  my @country_set = ($country_id, $country_id2);

  # 通常の宣戦布告
  {
    $diplomacy_model->add($declare_war_params);
    ok not $diplomacy_model->can_attack(@country_set, $now_game_date);
    ok not $diplomacy_model->can_passage(@country_set, $now_game_date);

    my $start_game_date = $declare_war_params->{start_game_date};
    ok $diplomacy_model->can_attack(@country_set, $start_game_date);
    ok $diplomacy_model->can_passage(@country_set, $start_game_date);
  }

  # 通行許可
  {
    my $allow_passege_params = +{
      %$declare_war_params,
      type => $diplomacy_model->CLASS->ALLOW_PASSAGE,
    };
    $diplomacy_model->add($allow_passege_params);
    ok not $diplomacy_model->can_attack(@country_set, $now_game_date);
    ok not $diplomacy_model->can_passage(@country_set, $now_game_date);
    my $allow_passege = $diplomacy_model->get($allow_passege_params);
    $allow_passege->accept;
    ok not $diplomacy_model->can_attack(@country_set, $now_game_date);
    ok $diplomacy_model->can_passage(@country_set, $now_game_date);
  }

  # 領土割譲・譲受
  {
    my $trade_territory_params = +{
      %$declare_war_params,
      type => $diplomacy_model->CLASS->CESSION_OR_ACCEPT_TERRITORY,
    };
    $diplomacy_model->add($trade_territory_params);
    my $trade_territory = $diplomacy_model->get($trade_territory_params);
    ok not $diplomacy_model->can_attack(@country_set, $now_game_date);
    ok $diplomacy_model->can_passage(@country_set, $now_game_date);
    $trade_territory->accept;
    ok $diplomacy_model->can_attack(@country_set, $now_game_date);
    ok $diplomacy_model->can_passage(@country_set, $now_game_date);
  }

  # 全部削除したら?
  {
    $diplomacy_model->delete_by_country_id($country_id);
    ok not $diplomacy_model->can_attack(@country_set, $now_game_date);
    ok not $diplomacy_model->can_passage(@country_set, $now_game_date);
  }

};

done_testing;
