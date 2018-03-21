use Test::Jikkoku;
use Jikkoku::Model::Skill;

my $CLASS = 'Jikkoku::Class::Skill::Command';
use_ok $CLASS;

my $container = Test::Jikkoku::Container->new;
my $chara     = $container->get('test.ext_chara');
my $skills    = Jikkoku::Model::Skill->new(chara => $chara)->get_all_with_result;

ok my $command = $CLASS->new(skills => $skills);
is $command->description, '統率官向けの、戦闘を有利にすすめるためのスキルです。';
for my $skill (@{ $command->get_belong_skills }) {
  ok $skill->DOES('Jikkoku::Class::Skill::Skill');
}
ok my $stuck = $command->get_skill('Close');
ok my $before_skills_id = $command->get_before_skills_id($stuck);
is_deeply $before_skills_id, ['Charge'];

done_testing;

