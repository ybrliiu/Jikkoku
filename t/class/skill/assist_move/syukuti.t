use Jikkoku;
use Test::More;
use Test::Exception;
use Test::Jikkoku::Container;

use Jikkoku::Model::Chara;
use Jikkoku::Model::BattleMap;
use Jikkoku::Class::Chara::ExtChara;

my $CLASS = 'Jikkoku::Class::Skill::AssistMove::Syukuti';
use_ok $CLASS;

my $container = Test::Jikkoku::Container->new;
my $chara = $container->get('test.ext_chara');
ok my $skill = $CLASS->new({ chara => $chara });
lives_ok { $skill->description_of_effect };
lives_ok { $skill->description_of_status };

done_testing;
