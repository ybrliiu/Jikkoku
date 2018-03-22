use Test::Jikkoku;

my $CLASS = 'Jikkoku::Model::Skill';
use_ok $CLASS;

my $container = Test::Jikkoku::Container->new;
my $chara     = $container->get('test.ext_chara');
ok my $model2 = Jikkoku::Model::Skill->new(chara => $chara);
ok @{ $model2->get_all_with_result };
ok my $skills = $model2->get_all_with_result;
ok my $skill = $skills->get({category => 'Invasion', id => 'AttackInWaves'});
is $skill->name, '波状攻撃';
diag $skill->description_of_effect;
diag explain [ map { $_->name } @$skills ];

done_testing;

