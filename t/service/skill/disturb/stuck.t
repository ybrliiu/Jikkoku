use Test::Jikkoku;

my $CLASS = 'Jikkoku::Service::Skill::Disturb::Stuck';
use_ok $CLASS;

my $container = Test::Jikkoku::Container->new;
my $chara = $container->get('test.ext_chara');
my $target = $container->get('test.ext_enemy');

subtest success_case => sub {
  my $stuck = $CLASS->new({
    chara     => $chara,
    target_id => $target->id,
  });
  eval { $stuck->exec };
  diag $@;
  ok 1;
};

done_testing;
