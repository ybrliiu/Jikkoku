package Jikkoku::Class::Skill::Invasion::VehementAttack {

  use Mouse;
  use Jikkoku;

  use constant {
    ACQUIRE_SIGN                         => 3,
    REQUIRE_ABILITIES                    => { force => 130 },
    INCREASE_ATTACK_POWER                => 20,
    INCREASE_ATTACK_POWER_LIMIT          => 60,
    NUM_OF_DIVIDE_OCCUR_RATIO_WHEN_SIEGE => 2,
  };

  has 'name'                 => ( is => 'ro', isa => 'Str', default => '猛攻' );
  has 'range'                => ( is => 'ro', isa => 'Int', lazy => 1, default => sub { $_[0]->chara->soldier->reach } );
  has 'max_occur_ratio'      => ( is => 'ro', isa => 'Num', default => 0.33 );
  has 'occur_ratio_coef'     => ( is => 'ro', isa => 'Num', default => 0.0011 );
  has 'consume_skill_point'  => ( is => 'ro', isa => 'Int', default => 15 );
  has 'increase_power_ratio' => ( is => 'ro', isa => 'Num', default => 0.05 );

  with qw(
    Jikkoku::Class::Skill::Invasion::Invasion
    Jikkoku::Class::Skill::Role::Purchasable
    Jikkoku::Class::Skill::Role::BattleLoopEventExecuter::DependOnAbilities
    Jikkoku::Service::BattleCommand::Battle::CharaPower::AttackAndDefencePowerAdjuster
  );

  around description_of_effect_before_body => sub { '' };

  sub depend_abilities { ['force'] }

  sub _build_items_of_depend_on_abilities { ['発動率'] }

  around description_of_effect_body => sub {
    my ($orig, $self) = @_;
    << "EOS"
侵攻側の時、攻守+@{[ $self->increase_power_ratio * 100 ]}%。<br>
また、戦闘中にイベント発生。<br>
EOS
  };

  around description_of_effect_note => sub {
    << "EOS"
発動毎に攻撃力が+@{[ INCREASE_ATTACK_POWER ]}され、敵にダメージを与える。<br>
※上昇した攻撃力は撤退すると元に戻る。<br>
※1回の出撃中に上昇する攻撃力は@{[ INCREASE_ATTACK_POWER_LIMIT ]}まで。<br>
※攻城戦は発動率が1/@{[ NUM_OF_DIVIDE_OCCUR_RATIO_WHEN_SIEGE ]}になる。<br>
EOS
  };

  sub adjust_attack_power {
    my ($self, $chara_power_adjuster_service) = @_;
    $chara_power_adjuster_service->orig_attack_power * $self->increase_power_ratio;
  }

  sub adjust_defence_power {
    my ($self, $chara_power_adjuster_service) = @_;
    $chara_power_adjuster_service->orig_defence_power < 0
      ? 0
      : $chara_power_adjuster_service->orig_defence_power * $self->increase_power_ratio;
  }

  __PACKAGE__->prepare;
  __PACKAGE__->meta->make_immutable;

}

1;

