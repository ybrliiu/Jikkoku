package Jikkoku::Class::Skill::AttackCastle2 {

  use Mouse;
  use Jikkoku;

  has 'name'          => ( is => 'ro', isa => 'Str', default => '攻城2' );
  has 'root_skill_id' => ( is => 'ro', isa => 'Str', default => 'SmallAttackCastle2' );

  with 'Jikkoku::Class::Skill::SkillCategory';

  sub description {
    '攻城戦向けのスキルです。攻城戦をするほどスキルの効果が上昇します';
  }

  __PACKAGE__->meta->make_immutable;

}

1;
