package Jikkoku::Class::Skill::AttackCastle2::SmallAttackCastle2 {

  use Mouse;
  use Jikkoku;

  use constant {
    ACQUIRE_SIGN        => 0,
    ACQUIRE_SIEGE_COUNT => 10,
  };

  has 'name'          => ( is => 'ro', isa => 'Str', default => '攻城2【小】' );
  has 'increase_turn' => ( is => 'ro', isa => 'Int', default => 1 );

  with qw(
    Jikkoku::Class::Skill::Skill
    Jikkoku::Class::Skill::Role::Practice
    Jikkoku::Class::Skill::AttackCastle2::Siege2
  );

  around _build_next_skills_id => sub { ['MediumAttackCastle2'] };

  # 上位互換のスキルのみ有効にするため, 
  # 上位のスキルを修得しているときはこのスキルを無効化する
  around is_available => sub {
    my ($orig, $self) = @_;
    $self->$orig() && grep { !$_->is_acquired } @{ $self->next_skills };
  };

  __PACKAGE__->meta->make_immutable;

}

1;

