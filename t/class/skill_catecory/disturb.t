use Test::Jikkoku;
use Jikkoku::Model::Skill;

my $CLASS = 'Jikkoku::Class::Skill::Disturb';
use_ok $CLASS;

my $container = Test::Jikkoku::Container->new;
my $chara     = $container->get('test.ext_chara');
my $skills    = Jikkoku::Model::Skill->new(chara => $chara)->get_all_with_result;

ok my $disturb = $CLASS->new(skills => $skills);
is $disturb->description, '文官向けの、相手の行動を妨害するスキルです。';
for my $skill (@{ $disturb->get_belong_skills }) {
  ok $skill->DOES('Jikkoku::Class::Skill::Skill');
}
ok my $stuck = $disturb->get_skill('Stuck');
ok my $before_skills_id = $disturb->get_before_skills_id($stuck);
is_deeply $before_skills_id, ['Confuse'];

done_testing;

