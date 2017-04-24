package Jikkoku::Class::Skill::Protect {

  use Mouse;
  use Jikkoku;

  has 'name'          => ( is => 'ro', isa => 'Str', default => '掩護' );
  has 'root_skill_id' => ( is => 'ro', isa => 'Str', default => 'Protect' );

  with 'Jikkoku::Class::Skill::SkillCategory';

  sub description { '' }

  __PACKAGE__->meta->make_immutable;

}

1;
