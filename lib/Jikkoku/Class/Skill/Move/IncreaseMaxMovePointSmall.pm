package Jikkoku::Class::Skill::Move::IncreaseMaxMovePointSmall {

  use Mouse;
  use Jikkoku;

  use constant ACQUIRE_SIGN => 1;

  has 'name'                          => ( is => 'ro', isa => 'Str', default => '駿足【小】' );
  has 'consume_skill_point'           => ( is => 'ro', isa => 'Int', default => 4 );
  has 'adjust_soldier_max_move_point' => ( is => 'ro', isa => 'Int', default => 1 );

  with qw(
    Jikkoku::Class::Skill::Skill
    Jikkoku::Class::Skill::Role::Purchasable
    Jikkoku::Class::Chara::Soldier::MaxMovePointAdjuster
  );

  around _build_next_skills_id => sub {
    ['DecreaseChargeMovePointTime'];
  };

  sub is_acquired {
    my $self = shift;
    $self->chara->skill('move') >= ACQUIRE_SIGN;
  }

  sub acquire {
    my $self = shift;
    $self->chara->skill(move => ACQUIRE_SIGN);
  }

  sub description_of_effect_body {
    my $self = shift;
    "最大移動Pが+@{[ $self->increase_max_move_point ]}される。";
  }

  __PACKAGE__->meta->make_immutable;

}

1;

