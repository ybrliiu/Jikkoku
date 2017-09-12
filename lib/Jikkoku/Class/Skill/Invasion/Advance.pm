package Jikkoku::Class::Skill::Invasion::Advance {

  use Mouse;
  use Jikkoku;

  use constant {
    NEED_FORCE                  => 115,
    REUSE_TIME                  => 1200,
    ACQUIRE_SIGN                => 2,
    INCREASE_ATTACK_POWER_TIME  => 410,
    DECREASE_DEFENCE_POWER_TIME => 200,
  };

  has 'name'                => ( is => 'ro', isa => 'Str', default => '進撃' );
  has 'consume_skill_point' => ( is => 'ro', isa => 'Int', default => 10 );

  with qw(
    Jikkoku::Class::Skill::Skill
    Jikkoku::Class::Skill::Role::Purchasable
  );

  around _build_next_skills_id => sub {
    [qw/ VehementAttack AttackInWaves /];
  };

  sub is_acquired {
    my $self = shift;
    $self->chara->skill('invasion') =~ /(??{ ACQUIRE_SIGN })/;
  }

  sub acquire {
    my $self = shift;
    $self->chara->skill( invasion => $self->chara->skill('invasion') . ':' . ACQUIRE_SIGN );
  }

  sub description_of_effect_body {
    my $self = shift;
    '侵攻側の時、使用してから410秒間攻撃力が25%上昇、その後200秒間>    守備力-50%。<br>防衛側の時、使用してから610秒間守備力-50%。（行動）';
  }

  __PACKAGE__->meta->make_immutable;

}

1;

