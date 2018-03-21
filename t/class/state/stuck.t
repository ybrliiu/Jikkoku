use Test::Jikkoku;

my $CLASS = 'Jikkoku::Class::State::Stuck';
use_ok $CLASS;

my $container = Test::Jikkoku::Container->new;
my $chara = $container->get('test.ext_chara');
ok my $stuck = $CLASS->new(chara => $chara);
ok !$stuck->is_available;
ok $stuck->set_state_for_chara({
  giver_id => 'someone',
  available_time => time + 1,
});
ok $stuck->is_available;

done_testing;
