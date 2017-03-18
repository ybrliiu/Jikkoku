package Jikkoku::Class::Skill::Disturb {

  use Mouse;
  use Jikkoku;

  has 'name'          => ( is => 'ro', isa => 'Str', default => '妨害' );
  has 'root_skill_id' => ( is => 'ro', isa => 'Str', default => '' );

  with 'Jikkoku::Class::Skill::SkillCategory';

  around _build_target_type => sub {
    ['文官'];
  };

  __PACKAGE__->meta->make_immutable;

}

1;
