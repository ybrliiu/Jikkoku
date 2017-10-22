package Jikkoku::Class::Skill::Invasion::Advance {

  use Mouse;
  use Jikkoku;

  use constant {
    ACQUIRE_SIGN                => 2,
    REQUIRE_ABILITIES           => {force => 115},
    INCREASE_ATTACK_POWER_TIME  => 410,
    DECREASE_DEFENCE_POWER_TIME => 200,
  };

  use constant effect_time => INCREASE_ATTACK_POWER_TIME + DECREASE_DEFENCE_POWER_TIME;

  has 'name'                => ( is => 'ro', isa => 'Str', default => '進撃' );
  has 'states'              => ( is => 'ro', isa => 'ArrayRef', lazy => 1, builder => '_build_states' );
  has 'reuse_time'          => ( is => 'ro', isa => 'Int', default => 1200 );
  has 'success_ratio'       => ( is => 'ro', isa => 'Num', default => 1.0 );
  has 'consume_morale'      => ( is => 'ro', isa => 'Int', default => 40 );
  has 'consume_skill_point' => ( is => 'ro', isa => 'Int', default => 10 );

  with qw(
    Jikkoku::Class::Skill::Invasion::Invasion
    Jikkoku::Class::Skill::Role::OccurReusetime
    Jikkoku::Class::Skill::Role::UsedInBattleMap
    Jikkoku::Class::Skill::Role::UsedInBattleMap::Purchasable
    Jikkoku::Class::Skill::Role::UsedInBattleMap::NotDependOnAbilities
  );

  sub _build_states {
    my $self = shift;
    [
      map { $self->chara->states->get($_) }
        qw/ AdvanceIncreaseAttackPower AdvanceDecreaseDefencePower /
    ];
  }

  around _build_next_skills_id => sub {
    [qw/ VehementAttack AttackInWaves /];
  };

  sub description_of_effect_body {
    my $self = shift;
    << "EOS"
侵攻側の時、使用してから@{[ INCREASE_ATTACK_POWER_TIME ]}秒間攻撃力が@{[ $self->states->[0]->attack_power_ratio * 100 ]}%上昇、
その後@{[ DECREASE_DEFENCE_POWER_TIME ]}秒間守備力@{[ $self->states->[1]->defence_power_ratio * 100 ]}%。<br>
防衛側の時、使用してから@{[ $self->effect_time ]}秒間守備力@{[ $self->states->[1]->defence_power_ratio * 100 ]}%。
EOS
  }

  __PACKAGE__->meta->make_immutable;

}

1;

