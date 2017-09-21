package Jikkoku::Class::Skill::Invasion::VehementAttack {

  use Mouse;
  use Jikkoku;

  use constant {
    NEED_FORCE   => 130,
    ACQUIRE_SIGN => 3,
  };

  has 'name'                 => ( is => 'ro', isa => 'Str', default => '猛攻' );
  has 'consume_skill_point'  => ( is => 'ro', isa => 'Int', default => 15 );
  has 'increase_power_ratio' => ( is => 'ro', isa => 'Num', default => 0.05 );

  with qw(
    Jikkoku::Class::Skill::Skill
    Jikkoku::Class::Skill::Role::Purchasable
    Jikkoku::Class::Skill::Invasion::Invasion
    Jikkoku::Service::BattleCommand::Battle::CharaPower::AttackAndDefencePowerAdjuster
  );

  sub description_of_effect_body {
    my $self = shift;
    '侵攻側の時、使用してから410秒間攻撃力が25%上昇、その後200秒間>    守備力-50%。<br>防衛側の時、使用してから610秒間守備力-50%。（行動）';
  }

  sub adjust_attack_power {
    my ($self, $chara_power_adjuster_service) = @_;
    $chara_power_adjuster_service->orig_attack_power * $self->increase_power_ratio;
  }

  sub adjust_defence_power {
    my ($self, $chara_power_adjuster_service) = @_;
    $chara_power_adjuster_service->orig_defence_power * $self->increase_power_ratio;
  }

  __PACKAGE__->meta->make_immutable;

}

1;

