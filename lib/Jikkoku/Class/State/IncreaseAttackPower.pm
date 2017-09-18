package Jikkoku::Class::State::IncreaseAttackPower {

  use Mouse;
  use Jikkoku;

  has 'name' => ( is => 'ro', isa => 'Str', default => '攻撃力上昇' );

  with qw(
    Jikkoku::Class::State::State
    Jikkoku::Class::State::Role::Counter
    Jikkoku::Service::BattleCommand::Battle::CharaPower::AttackPowerAdjuster
  );

  sub description { '出撃中にスキル効果で上昇している攻撃力の値です。' }

  sub adjust_attack_power {
    my ($self, $chara_power_adjuster_service) = @_;
    $self->count;
  }

  __PACKAGE__->meta->make_immutable;

}

1;

