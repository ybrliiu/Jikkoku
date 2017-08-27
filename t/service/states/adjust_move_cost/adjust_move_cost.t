use Jikkoku;
use Test::More;
use Test::Exception;

use Jikkoku::Model::Chara;
use Jikkoku::Class::Chara::ExtChara;

use_ok 'Jikkoku::Service::States::AdjustMoveCost::AdjustMoveCost';

# 準備
my $chara_model = Jikkoku::Model::Chara->new;
my $_chara = $chara_model->get('ybrliiu');
my $chara  = Jikkoku::Class::Chara::ExtChara->new(chara => $_chara);
my $state = $chara->states->get('Stuck');

subtest 'adjust case' => sub {

  $state->set_state_for_chara({
    giver_id       => 'someone',
    available_time => time + 1,
  });

  my $service;
  lives_ok {
    $service = Jikkoku::Service::States::AdjustMoveCost::AdjustMoveCost->new({
      chara       => $chara,
      origin_cost => 5,
    });
  };

  is $service->adjust_move_cost, 3.5;

};

subtest 'disabled case' => sub {

  $state->set_state_for_chara({
    giver_id       => 'someone',
    available_time => time - 1,
  });

  ok !Jikkoku::Service::States::AdjustMoveCost::AdjustMoveCost->new({
    chara       => $chara,
    origin_cost => 100,
  })->adjust_move_cost;

};

done_testing;

