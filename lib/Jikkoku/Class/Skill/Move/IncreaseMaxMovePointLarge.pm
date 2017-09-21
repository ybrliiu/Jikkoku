package Jikkoku::Class::Skill::Move::IncreaseMaxMovePointLarge {

  use Mouse;
  use Jikkoku;

  use constant ACQUIRE_SIGN => 3;

  has 'name'                            => ( is => 'ro', isa => 'Str', default => '駿足【大】' );
  has 'consume_skill_point'             => ( is => 'ro', isa => 'Int', default => 12 );
  has 'increase_soldier_max_move_point' => ( is => 'ro', isa => 'Int', default => 3 );

  with qw(
    Jikkoku::Class::Skill::Skill
    Jikkoku::Class::Skill::Role::Purchasable
    Jikkoku::Class::Chara::Soldier::MaxMovePointAdjuster
  );

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
    "最大移動Pが+@{[ $self->increase_soldier_max_move_point ]}される。";
  }

  sub adjust_soldier_max_move_point {
    my ($self, $orig_max_move_point) = @_;
    $self->increase_soldier_max_move_point;
  }

  __PACKAGE__->meta->make_immutable;

}

1;

