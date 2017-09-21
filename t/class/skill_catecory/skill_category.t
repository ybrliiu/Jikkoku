use Jikkoku;
use Test::More;
use Test::Exception;

use Jikkoku::Model::Chara;
use Jikkoku::Model::Skill;
use Jikkoku::Class::Chara::ExtChara;

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

my $chara_model      = Jikkoku::Model::Chara->new;
my $chara            = Jikkoku::Class::Chara::ExtChara->new(chara => $chara_model->get_with_option('ybrliiu')->get);
my $skills           = Jikkoku::Model::Skill->new(chara => $chara)->get_all_with_result;
ok my $test_category = Jikkoku::Class::Skill::TestCategory->new(skills => $skills);
is $test_category->id, 'TestCategory';

done_testing;
