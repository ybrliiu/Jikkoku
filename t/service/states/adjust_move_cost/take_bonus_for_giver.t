use Jikkoku;
use Test::More;
use Test::Exception;

use Jikkoku::Model::Chara;
use Jikkoku::Class::Chara::ExtChara;
use Jikkoku::Service::States::AdjustMoveCost::AdjustMoveCost;

use_ok 'Jikkoku::Service::States::AdjustMoveCost::TakeBonusForGiver';

# 準備
my $chara_model = Jikkoku::Model::Chara->new;
my $_chara = $chara_model->get('ybrliiu');
my $chara  = Jikkoku::Class::Chara::ExtChara->new(chara => $_chara);
my $state = $chara->states->get('Stuck');
$state->set_state_for_chara({
  giver_id       => 'define',
  available_time => time + 1,
});
my $adjust_move_cost_service = Jikkoku::Service::States::AdjustMoveCost::AdjustMoveCost->new({
  chara       => $chara,
  origin_cost => 100,
});
my $old_giver = $chara_model->get('define');

ok(
  my $service = Jikkoku::Service::States::AdjustMoveCost::TakeBonusForGiver->new({
    chara_model              => $chara_model,
    adjust_move_cost_service => $adjust_move_cost_service,
  })
);

lives_ok { $service->exec };

my $new_giver = $chara_model->get('define');
is $new_giver->book_power, $old_giver->book_power + $state->increase_giver_book_power_num;
is $new_giver->contribute, $old_giver->contribute + $state->increase_giver_contribute_num;

my $ext_giver = Jikkoku::Class::Chara::ExtChara->new(chara => $new_giver);
like $ext_giver->battle_logger->get(1)->[0], qr/【足止め】undefの付与した足止めが効果を発動しました。/;

done_testing;

