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

  sub can_use {
    my $self = shift;
    0;
  }

  sub description {
  }

  around use => sub {
    my ($orig, $self, $battle_service) = @_;
    my $enemy = $battle_service->target;
    if ( $enemy->id eq $enemy->WALL_ID ) {
      Jikkoku::Class::BattleMode::Exception
        ->throw($self->name . 'は攻城戦では使えません');
    }
    $self->$orig($battle_service);
  };

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
    $chara_power_adjuster_service->orig_defence_power < 0
      ? 0
      : $chara_power_adjuster_service->orig_defence_power * $self->adjust_power_ratio;
  }

  sub adjust_enemy_attack_power {
    my ($self, $enemy_power_adjuster_service) = @_;
    $enemy_power_adjuster_service->orig_enemy_attack_power * $self->adjust_power_ratio;
  }

  sub adjust_enemy_defence_power {
    my ($self, $enemy_power_adjuster_service) = @_;
    $enemy_power_adjuster_service->orig_enemy_defence_power < 0
      ? 0
      : $enemy_power_adjuster_service->orig_enemy_defence_power * $self->adjust_power_ratio;
  }

  __PACKAGE__->meta->make_immutable;

}

1;

