package Jikkoku::Class::Skill::Move::DecreaseChargeMovePointTime {

  use Mouse;
  use Jikkoku;

  use constant ACQUIRE_SIGN => 2;

  has 'name'                                    => ( is => 'ro', isa => 'Str', default => '迅速' );
  has 'consume_skill_point'                     => ( is => 'ro', isa => 'Int', default => 10 );
  has 'decrease_soldier_charge_move_point_time' => ( is => 'ro', isa => 'Int', default => -20 );

  with qw(
    Jikkoku::Class::Skill::Skill
    Jikkoku::Class::Skill::Role::Purchasable
    Jikkoku::Class::Chara::Soldier::ChargeMovePointAdjuster
  );

  around _build_next_skills_id => sub {
    ['IncreaseMaxMovePointLarge'];
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
    "移動ポイント補充にかかる時間が@{[ $self->adjust_charge_move_point_time * -1 ]}秒短縮される。";
  }

  sub adjust_soldier_charge_move_point_time {
    my ($self, $orig_time) = @_;
    $self->decrease_soldier_charge_move_point_time;
  }

  __PACKAGE__->meta->make_immutable;

}

1;

