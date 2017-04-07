use v5.14;
use warnings;
use Test::More;
use Test::Exception;

my $CLASS = 'Jikkoku::Class::State::Confuse';
use_ok $CLASS;
require Jikkoku::Model::Chara;
my $chara_model = Jikkoku::Model::Chara->new;
my $chara = $chara_model->get_with_option('ybrliiu')->get;
ok my $confuse = $CLASS->new(chara => $chara);
ok !$confuse->is_available;
ok $confuse->set_state_for_chara({
  giver_id => 'someone',
  available_time => time + 1,
});
ok $confuse->is_available;
is $confuse->decrease_battle_action_success_ratio_num, -0.3;

done_testing;
