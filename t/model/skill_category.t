use Test::Jikkoku;

my $CLASS = 'Jikkoku::Model::SkillCategory';
use_ok $CLASS;

my $container = Test::Jikkoku::Container->new;
my $chara     = $container->get('test.ext_chara');
ok my $model = Jikkoku::Model::SkillCategory->new(skills => $chara->skills);
ok my $category = $model->get('Invasion');
is $category->name, '侵攻';
ok my $result = $model->get_all_with_result;
ok my $category2 = $result->get('Disturb');
diag explain [ map { $_->name } @$result ];

done_testing;

