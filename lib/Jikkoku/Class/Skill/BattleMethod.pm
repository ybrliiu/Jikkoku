package Jikkoku::Class::Skill::BattleMethod {

  use Mouse;
  use Jikkoku;

  has 'name'          => ( is => 'ro', isa => 'Str', default => '戦闘術' );
  has 'root_skill_id' => ( is => 'ro', isa => 'Str', default => 'KeisuAttack' );

  with 'Jikkoku::Class::Skill::SkillCategory';

  around _build_target_type => sub {
    ['武官'];
  };

  sub description {
    my $self = shift;
    '戦闘を有利にするスキルです。';
  }

  __PACKAGE__->meta->make_immutable;

}

1;
