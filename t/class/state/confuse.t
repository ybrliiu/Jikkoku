use Jikkoku;
use Test::More;
use Test::Exception;

use Jikkoku::Model::Chara;
use Jikkoku::Class::Chara::ExtChara;

my $CLASS = 'Jikkoku::Class::State::Confuse';
use_ok $CLASS;
my $chara_model = Jikkoku::Model::Chara->new;
my $chara = Jikkoku::Class::Chara::ExtChara->new(chara => $chara_model->get_with_option('ybrliiu')->get);
ok my $confuse = $CLASS->new(chara => $chara);
ok !$confuse->is_available;
ok $confuse->set_state_for_chara({
  giver_id => 'someone',
  available_time => time + 1,
});
ok $confuse->is_available;
is $confuse->decrease_battle_action_success_ratio_num, -0.3;

done_testing;
