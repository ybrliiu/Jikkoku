package Jikkoku::Class::Skill::Command {

  use Mouse;
  use Jikkoku;

  has 'name'          => ( is => 'ro', isa => 'Str', default => '指揮' );
  has 'root_skill_id' => ( is => 'ro', isa => 'Str', default => 'Charge' );

  with 'Jikkoku::Class::Skill::SkillCategory';

  around _build_target_type => sub {
    ['統率官'];
  };

  sub description {
    my $self = shift;
    '戦闘を有利にすすめるためのスキルです。';
  }

  __PACKAGE__->meta->make_immutable;

}

1;
