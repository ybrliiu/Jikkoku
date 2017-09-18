package Jikkoku::Class::BattleMode::Storm {

  use Mouse;
  use Jikkoku;

  has 'name'               => ( is => 'ro', isa => 'Str', default => '強襲' );
  has 'consume_morale'     => ( is => 'ro', isa => 'Int', default => 20 );
  has 'adjust_power_ratio' => ( is => 'ro', isa => 'Num', lazy => 1, builder => '_build_adjust_power_ratio' );

  with qw(
    Jikkoku::Class::BattleMode::BattleMode
    Jikkoku::Service::BattleCommand::Battle::CharaPower::AttackAndDefencePowerAdjuster
    Jikkoku::Service::BattleCommand::Battle::CharaPower::EnemyAttackAndDefencePowerAdjuster
  );

  sub _build_adjust_power_ratio {
    my $self = shift;
    ( int( $self->chara->force / 50 ) + 3 ) / 100;
  }

  sub adjust_attack_power {
    my ($self, $chara_power_adjuster_service) = @_;
    $chara_power_adjuster_service->orig_attack_power * $self->adjust_power_ratio;
  }

  sub adjust_defence_power {
    my ($self, $chara_power_adjuster_service) = @_;
    $chara_power_adjuster_service->orig_defence_power * $self->adjust_power_ratio;
  }

  sub adjust_enemy_attack_power {
    my ($self, $enemy_power_adjuster_service) = @_;
    $enemy_power_adjuster_service->orig_attack_power * $self->adjust_power_ratio;
  }

  sub adjust_enemy_defence_power {
    my ($self, $enemy_power_adjuster_service) = @_;
    $enemy_power_adjuster_service->orig_defence_power * $self->adjust_power_ratio;
  }

  __PACKAGE__->meta->make_immutable;

}

1;
