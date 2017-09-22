package Jikkoku::Class::Skill::AttackCastle2::GreatAttackCastle2 {

  use Mouse;
  use Jikkoku;

  use constant {
    ACQUIRE_SIGN        => 2,
    ACQUIRE_SIEGE_COUNT => 100,
  };

  has 'name'          => ( is => 'ro', isa => 'Str', default => '攻城2【大】' );
  has 'increase_turn' => ( is => 'ro', isa => 'Int', default => 3 );

  with qw(
    Jikkoku::Class::Skill::Skill
    Jikkoku::Class::Skill::Role::Practice
    Jikkoku::Class::Skill::AttackCastle2::Siege2
  );

  __PACKAGE__->meta->make_immutable;

}

1;

