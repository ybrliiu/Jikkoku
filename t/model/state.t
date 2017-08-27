use Jikkoku;
use Test::More;
use Test::Exception;

use Jikkoku::Model::Chara;
use Jikkoku::Class::Chara::ExtChara;
use Jikkoku::Service::States::AdjustMoveCost::AdjustMoveCost;
use Jikkoku::Service::States::AdjustBattleActionSuccessRatio::AdjustSuccessRatio;

my $CLASS = 'Jikkoku::Model::State';
use_ok $CLASS;
my $chara_model = Jikkoku::Model::Chara->new;
my $_chara = $chara_model->get_with_option('ybrliiu')->get;
ok $CLASS->new(chara => $_chara);
my $chara  = Jikkoku::Class::Chara::ExtChara->new(chara => $_chara);
ok $chara->states;
ok my $state = $chara->states->get('SmallDivineProtection');
ok $state->DOES('Jikkoku::Class::State::State');

subtest 'adjust_move_cost' => sub {

  my $stuck = $chara->states->get('Stuck');

  $stuck->set_state_for_chara({
    giver_id       => 'someone',
    available_time => time + 1,
  });

  is( Jikkoku::Service::States::AdjustMoveCost::AdjustMoveCost->new({
    chara       => $chara,
    origin_cost => 5,
  })->adjust_move_cost, 3.5 );

  $stuck->set_state_for_chara({
    giver_id       => 'someone',
    available_time => time - 1,
  });

  ok !Jikkoku::Service::States::AdjustMoveCost::AdjustMoveCost->new({
    chara       => $chara,
    origin_cost => 100,
  })->adjust_move_cost;

};

subtest 'adjust_battle_action_success_ratio' => sub {

  my $confuse = $chara->states->get('Confuse');
  
  $confuse->set_state_for_chara({
    giver_id       => 'someone',
    available_time => time + 1,
  });

  is( Jikkoku::Service::States::AdjustBattleActionSuccessRatio::AdjustSuccessRatio->new({
    chara                => $chara,
    origin_success_ratio => 1,
  })->adjust_success_ratio, -0.3 );

  $confuse->set_state_for_chara({
    giver_id       => 'someone',
    available_time => time - 1,
  });

  ok !Jikkoku::Service::States::AdjustBattleActionSuccessRatio::AdjustSuccessRatio->new({
    chara                => $chara,
    origin_success_ratio => 1,
  })->adjust_success_ratio;

};

lives_ok { $chara->states->get_all };

done_testing;
