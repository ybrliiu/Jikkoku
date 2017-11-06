use Jikkoku;
use Test::More;

use Jikkoku::Model::Chara;
use Jikkoku::Model::BattleMap;
use Jikkoku::Class::Chara::ExtChara;

my $CLASS = 'Jikkoku::Class::Skill::Command::Charge';
use_ok $CLASS;

my $chara_model = Jikkoku::Model::Chara->new;
my $battle_map_model = Jikkoku::Model::BattleMap->new;
my $chara = Jikkoku::Class::Chara::ExtChara->new(chara => $chara_model->get('ybrliiu'));
ok my $skill = $CLASS->new({ chara => $chara });

done_testing;
