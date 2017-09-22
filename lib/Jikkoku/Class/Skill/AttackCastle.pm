package Jikkoku::Class::Skill::AttackCastle {

  use Mouse;
  use Jikkoku;

  has 'name'          => ( is => 'ro', isa => 'Str', default => '攻城1' );
  has 'root_skill_id' => ( is => 'ro', isa => 'Str', default => 'SmallAttackCastle' );

  with 'Jikkoku::Class::Skill::SkillCategory';

  sub description {
    '攻城戦向けのスキルです。'
      . 'このカテゴリに属するスキルは特定の兵士を雇っている時にのみ効果を発動します。'
      . 'また、カテゴリ内のスキルは相互に関係をもっていません。';
  }

  __PACKAGE__->meta->make_immutable;

}

1;
