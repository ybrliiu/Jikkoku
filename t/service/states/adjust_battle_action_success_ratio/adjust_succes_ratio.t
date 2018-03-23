use Test::Jikkoku;

my $CLASS = 'Jikkoku::Service::States::AdjustBattleActionSuccessRatio::AdjustSuccessRatio';
use_ok $CLASS;

# 準備
my $container = Test::Jikkoku::Container->new;
my $chara = $container->get('test.ext_chara');
my $confuse = $chara->states->get('Confuse');

subtest 'adjust case' => sub {
  
  $confuse->set_state_for_chara({
    giver_id       => 'someone',
    available_time => time + 1,
  });

  my $service;
  lives_ok {
    $service = $CLASS->new({
      chara                => $chara,
      origin_success_ratio => 1,
    });
  };

  is $service->adjust_success_ratio, -0.3;

};

done_testing;

