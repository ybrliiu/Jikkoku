use Test::Jikkoku;

my $container = Test::Jikkoku::Container->new;
my $chara = $container->get('test.ext_chara');

subtest Acceleration => sub {
  my $CLASS = 'Jikkoku::Class::Skill::AssistMove::Acceleration';
  use_ok $CLASS;
  ok my $skill = $CLASS->new({ chara => $chara });
  lives_ok { $skill->description_of_effect };
  lives_ok { $skill->description_of_status };
};

subtest Avoid => sub {
  my $CLASS = 'Jikkoku::Class::Skill::AssistMove::Avoid';
  use_ok $CLASS;
  ok my $skill = $CLASS->new({ chara => $chara });
  lives_ok { $skill->description_of_effect };
  lives_ok { $skill->description_of_status };
};

subtest Kintoun => sub {
  my $CLASS = 'Jikkoku::Class::Skill::AssistMove::Kintoun';
  use_ok $CLASS;
  ok my $skill = $CLASS->new({ chara => $chara });
  lives_ok { $skill->description_of_effect };
  lives_ok { $skill->description_of_status };
};

subtest Syukuti => sub {
  my $CLASS = 'Jikkoku::Class::Skill::AssistMove::Syukuti';
  use_ok $CLASS;
  ok my $skill = $CLASS->new({ chara => $chara });
  lives_ok { $skill->description_of_effect };
  lives_ok { $skill->description_of_status };
};

done_testing;
