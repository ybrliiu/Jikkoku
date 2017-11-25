use Jikkoku;
use Test::More;
use Test::Exception;

use Jikkoku::Model::Chara;
use Jikkoku::Model::Skill;
use Jikkoku::Class::Chara::ExtChara;

my $CLASS = 'Jikkoku::Class::Skill::AssistMove';
use_ok $CLASS;

my $chara_model = Jikkoku::Model::Chara->new;
my $chara       = Jikkoku::Class::Chara::ExtChara->new(chara => $chara_model->get_with_option('ybrliiu')->get);
my $skills      = Jikkoku::Model::Skill->new(chara => $chara)->get_all_with_result;

ok my $command = $CLASS->new(skills => $skills);
is $command->description, '仁官向けの、味方の移動を補助するスキルです。';
for my $skill (@{ $command->get_belong_skills }) {
  ok $skill->DOES('Jikkoku::Class::Skill::Skill');
}
ok my $stuck = $command->get_skill('Acceleration');
ok my $before_skills_id = $command->get_before_skills_id($stuck);
is_deeply $before_skills_id, ['Syukuti'];

done_testing;

