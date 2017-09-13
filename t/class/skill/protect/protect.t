use Jikkoku;
use Test::More;
use Test::Exception;

use Jikkoku::Model::Chara;
use Jikkoku::Class::Chara::ExtChara;

my $CLASS = 'Jikkoku::Class::Skill::Protect::Protect';
use_ok $CLASS;

my $chara_model = Jikkoku::Model::Chara->new;
my $chara = Jikkoku::Class::Chara::ExtChara->new(chara => $chara_model->get_with_option('meemee')->get);
ok my $protect = $CLASS->new({ chara => $chara });

my $description_of_status = <<'EOS';
消費士気 : 10<br>
再使用時間 : 240秒<br>
成功率 : 100%
EOS
chomp($description_of_status);
is $protect->description_of_status, $description_of_status;

done_testing;
