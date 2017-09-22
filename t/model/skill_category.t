use Jikkoku;
use Test::More;
use Test::Exception;

use Jikkoku::Model::Chara;
use Jikkoku::Class::Chara::ExtChara;

my $CLASS = 'Jikkoku::Model::SkillCategory';
use_ok $CLASS;

my $chara_model = Jikkoku::Model::Chara->new;
my $chara = Jikkoku::Class::Chara::ExtChara->new(chara => $chara_model->get_with_option('ybrliiu')->get);
ok my $model = Jikkoku::Model::SkillCategory->new(skills => $chara->skills);
ok my $category = $model->get('Invasion');
is $category->name, '侵攻';
ok my $result = $model->get_all_with_result;
ok my $category2 = $result->get('Disturb');

done_testing;

