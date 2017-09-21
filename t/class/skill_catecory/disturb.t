use Jikkoku;
use Test::More;
use Test::Exception;

use Jikkoku::Model::Chara;
use Jikkoku::Model::Skill;
use Jikkoku::Class::Chara::ExtChara;

my $CLASS = 'Jikkoku::Class::Skill::Disturb';
use_ok $CLASS;

my $chara_model = Jikkoku::Model::Chara->new;
my $chara       = Jikkoku::Class::Chara::ExtChara->new(chara => $chara_model->get_with_option('ybrliiu')->get);
my $skills      = Jikkoku::Model::Skill->new(chara => $chara)->get_all_with_result;

ok my $disturb = $CLASS->new(skills => $skills);
is $disturb->description, '文官向けの、相手の行動を妨害するスキルです。';
for my $skill (@{ $disturb->get_belong_skills }) {
  ok $skill->DOES('Jikkoku::Class::Skill::Skill');
}
ok my $stuck = $disturb->get_skill('Stuck');
ok my $before_skills_id = $disturb->get_before_skills_id($stuck);
is_deeply $before_skills_id, ['Confuse'];

done_testing;

