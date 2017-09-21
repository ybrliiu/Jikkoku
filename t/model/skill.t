use Jikkoku;
use Test::More;
use Test::Exception;

use Jikkoku::Model::Chara;
use Jikkoku::Class::Chara::ExtChara;

my $CLASS = 'Jikkoku::Model::Skill';
use_ok $CLASS;

my $chara_model = Jikkoku::Model::Chara->new;
my $chara = Jikkoku::Class::Chara::ExtChara->new(chara => $chara_model->get_with_option('ybrliiu')->get);
ok my $model2 = Jikkoku::Model::Skill->new(chara => $chara);
ok @{ $model2->get_all_with_result };
ok my $skills = $model2->get_all_with_result;
ok my $skill = $skills->get({category => 'Invasion', id => 'AttackInWaves'});
is $skill->name, '波状攻撃';

done_testing;

