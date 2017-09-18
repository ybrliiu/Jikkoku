package Jikkoku::Class::Skill::HasFormation::Genjyou {

  use Mouse;
  use Jikkoku;

  has 'name'           => ( is => 'ro', isa => 'Str', default => '玄襄陣' );
  has 'decrease_ratio' => ( is => 'ro', isa => 'Num', default => 0.15 );

  with qw(
    Jikkoku::Class::Skill::Skill
    Jikkoku::Class::Skill::Role::HasFormation
    Jikkoku::Service::BattleCommand::Battle::CharaPower::EnemyAttackPowerAdjuster
    Jikkoku::Service::BattleCommand::Battle::CharaPower::EnemyDefencePowerAdjuster
  );

  sub is_acquired {
    my $self = shift;
    $self->chara->formation->name eq $self->name;
  }

  sub acquire {}

  sub description_of_effect_body {
    my $self = shift;
    '敵攻守-' . $self->decrease_ratio * 100 . '%。';
  }

  sub adjust_enemy_attack_power {
    my ($self, $enemy_power_adjuster_service) = @_;
    $enemy_power_adjuster_service->orig_attack_power * $self->decrease_ratio;
  }

  sub adjust_enemy_defence_power {
    my ($self, $enemy_power_adjuster_service) = @_;
    $enemy_power_adjuster_service->orig_defence_power * $self->decrease_ratio;
  }

  __PACKAGE__->meta->make_immutable;

}

1;

