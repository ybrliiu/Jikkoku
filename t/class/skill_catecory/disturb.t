use Jikkoku;
use Test::More;
use Test::Exception;

my $CLASS = 'Jikkoku::Class::Skill::Disturb';
use_ok $CLASS;

require Jikkoku::Model::Chara;
require Jikkoku::Model::Skill;
my $chara_model = Jikkoku::Model::Chara->new;
my $chara       = $chara_model->get_with_option('ybrliiu')->get;
my $skill_model = Jikkoku::Model::Skill->new(chara => $chara);

ok my $disturb = $CLASS->new(skill_model => $skill_model);
is $disturb->description, '文官向けの、相手の行動を妨害するスキルです。';
for my $skill (@{ $disturb->get_belong_skills }) {
  ok $skill->DOES('Jikkoku::Class::Skill::Skill');
}
ok my $stuck = $disturb->get_skill('Stuck');
ok my $before_skills_id = $disturb->get_before_skills_id($stuck);
is_deeply $before_skills_id, ['Confuse'];

done_testing;

