package Jikkoku::Class::Skill::Invasion::AttackInWaves {

  use Mouse;
  use Jikkoku;

  use constant {
    ACQUIRE_SIGN      => 4,
    REQUIRE_ABILITIES => {force => 130},
  };

  has 'name'                 => ( is => 'ro', isa => 'Str', default => '波状攻撃' );
  has 'battle_mode'          => ( is => 'ro', does => 'Jikkoku::Class::BattleMode::BattleMode', lazy => 1, builder => '_build_battle_mode' );
  has 'consume_skill_point'  => ( is => 'ro', isa => 'Int', default => 15 );
  has 'increase_power_ratio' => ( is => 'ro', isa => 'Num', default => 0.05 );

  with qw(
    Jikkoku::Class::Skill::Invasion::Invasion
    Jikkoku::Class::Skill::Role::Purchasable
    Jikkoku::Service::BattleCommand::Battle::CharaPower::AttackAndDefencePowerAdjuster
  );

  sub _build_battle_mode {
    my $self = shift;
    $self->chara->battle_modes->get($self->id);
  }

  sub description_of_effect_body {
    my $self = shift;
    << "EOS"
侵攻側の時、攻守+@{[ $self->increase_power_ratio * 100 ]}%、@{[ $self->battle_mode->name ]}モード使用可能。<br>
<strong>@{[ $self->battle_mode->name ]}モード</strong> : @{[ $self->battle_mode->description ]}
EOS
  }

  around description_of_status_about_occur_ratio => sub {
    my ($orig, $self) = @_;
    '発動率 : ' . $self->battle_mode->occur_ratio * 100 . '%';
  };

  around description_of_status_about_range => sub {
    my ($orig, $self) = @_;
    'リーチ : ' . $self->battle_mode->range;
  };

  around description_of_status_about_consume_morale => sub {
    my ($orig, $self) = @_;
    '消費士気 : ' . $self->battle_mode->consume_morale;
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

  __PACKAGE__->meta->make_immutable;

# battle mode 

}

1;

