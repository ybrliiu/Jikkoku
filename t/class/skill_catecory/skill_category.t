use Jikkoku;
use Test::More;
use Test::Exception;

my $CLASS = 'Jikkoku::Class::Skill::SkillCategory';
use_ok $CLASS;

package Jikkoku::Class::Skill::TestCategory {

  use Mouse;
  use Jikkoku;

  has 'name'          => ( is => 'ro', isa => 'Str', default => 'テストカテゴリ' );
  has 'root_skill_id' => ( is => 'ro', isa => 'Str', default => 'RootSkill' );

  with 'Jikkoku::Class::Skill::SkillCategory';

  sub description {
    my $self = shift;
    'テストカテゴリですあああ';
  }

  __PACKAGE__->meta->make_immutable;

}

require Jikkoku::Model::Chara;
require Jikkoku::Model::Skill;
my $chara_model      = Jikkoku::Model::Chara->new;
my $chara            = $chara_model->get_with_option('ybrliiu')->get;
my $skill_model      = Jikkoku::Model::Skill->new(chara => $chara);
ok my $test_category = Jikkoku::Class::Skill::TestCategory->new(skill_model => $skill_model);
is $test_category->id, 'TestCategory';

done_testing;
