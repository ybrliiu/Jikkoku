use Jikkoku;
use Test::More;
use Test::Exception;

use Jikkoku::Model::Chara;
use Jikkoku::Class::Chara::ExtChara;

use_ok 'Jikkoku::Service::States::AdjustBattleActionSuccessRatio::AdjustSuccessRatio';

# 準備
my $chara_model = Jikkoku::Model::Chara->new;
my $_chara  = $chara_model->get('ybrliiu');
my $chara   = Jikkoku::Class::Chara::ExtChara->new(chara => $_chara);
my $confuse = $chara->states->get('Confuse');

subtest 'adjust case' => sub {
  
  $confuse->set_state_for_chara({
    giver_id       => 'someone',
    available_time => time + 1,
  });

  my $service;
  lives_ok {
    $service = Jikkoku::Service::States::AdjustBattleActionSuccessRatio::AdjustSuccessRatio->new({
      chara                => $chara,
      origin_success_ratio => 1,
    });
  };

  is $service->adjust_success_ratio, -0.3;

};

done_testing;

