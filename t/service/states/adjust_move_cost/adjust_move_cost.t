use Test::Jikkoku;

my $CLASS = 'Jikkoku::Service::States::AdjustMoveCost::AdjustMoveCost';
use_ok $CLASS;

# 準備
my $container = Test::Jikkoku::Container->new;
my $chara = $container->get('test.ext_chara');
my $state = $chara->states->get('Stuck');

subtest 'adjust case' => sub {

  $state->set_state_for_chara({
    giver_id       => 'someone',
    available_time => time + 1,
  });

  my $service;
  lives_ok {
    $service = $CLASS->new({
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

