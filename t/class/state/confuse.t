use Test::Jikkoku;

my $CLASS = 'Jikkoku::Class::State::Confuse';
use_ok $CLASS;

my $container = Test::Jikkoku::Container->new;
my $chara = $container->get('test.ext_chara');
ok my $confuse = $CLASS->new(chara => $chara);
ok !$confuse->is_available;
ok $confuse->set_state_for_chara({
  giver_id => 'someone',
  available_time => time + 1,
});
ok $confuse->is_available;
is $confuse->decrease_battle_action_success_ratio_num, -0.3;

done_testing;
