use Test::Jikkoku;

my $container = Test::Jikkoku::Container->new;
my $chara = $container->get('test.ext_chara');

subtest Protect => sub {
  my $CLASS = 'Jikkoku::Class::Skill::Protect::Protect';
  use_ok $CLASS;
  ok my $protect = $CLASS->new({ chara => $chara });
  my $description_of_status = <<'EOS';
消費士気 : 10<br>
再使用時間 : 240秒<br>
成功率 : 100%
EOS
  chomp($description_of_status);
  is $protect->description_of_status, $description_of_status;
};

done_testing;
