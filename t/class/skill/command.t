use Test::Jikkoku;

my $container = Test::Jikkoku::Container->new;
my $chara = $container->get('test.ext_chara');

subtest Charge => sub {
  my $CLASS = 'Jikkoku::Class::Skill::Command::Charge';
  use_ok $CLASS;
  ok my $skill = $CLASS->new({ chara => $chara });
};

subtest Close => sub {
  my $CLASS = 'Jikkoku::Class::Skill::Command::Close';
  use_ok $CLASS;
  ok my $skill = $CLASS->new({ chara => $chara });
  diag $skill->description_of_effect;
};

subtest Offensive => sub {
  my $CLASS = 'Jikkoku::Class::Skill::Command::Offensive';
  use_ok $CLASS;
  ok my $skill = $CLASS->new({ chara => $chara });
  diag $skill->description_of_effect;
};

subtest RegroupFormation => sub {
  my $CLASS = 'Jikkoku::Class::Skill::Command::RegroupFormation';
  use_ok $CLASS;
  ok my $skill = $CLASS->new({ chara => $chara });
  diag $skill->description_of_effect;
};

subtest Surround => sub {
  my $CLASS = 'Jikkoku::Class::Skill::Command::Surround';
  use_ok $CLASS;
  ok my $skill = $CLASS->new({ chara => $chara });
  diag $skill->description_of_effect;
};

done_testing;
