package Jikkoku::Class::Skill::AssistMove {

  use Mouse;
  use Jikkoku;

  has 'name'          => ( is => 'ro', isa => 'Str', default => '移動補助' );
  has 'root_skill_id' => ( is => 'ro', isa => 'Str', default => 'Syukuti' );

  with 'Jikkoku::Class::Skill::SkillCategory';

  around _build_target_type => sub {
    ['仁官'];
  };

  sub description {
    my $self = shift;
    '味方の移動を補助するスキルです。';
  }

  __PACKAGE__->meta->make_immutable;

}

1;
