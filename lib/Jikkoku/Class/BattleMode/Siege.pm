package Jikkoku::Class::BattleMode::Siege {

  use Mouse;
  use Jikkoku;

  use constant {
    ENEMY_SOLDIER_NUM           => 30,
    INCREASE_ATTACK_POWER_RATIO => 1.5,
  };

  has 'name'           => ( is => 'ro', isa => 'Str', default => '包囲' );
  has 'consume_morale' => ( is => 'ro', isa => 'Int', default => 20 );

  with qw(
    Jikkoku::Class::BattleMode::BattleMode
    Jikkoku::Service::BattleCommand::Battle::CharaPower::AttackPowerAdjuster
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
    if ( $battle_service->is_siege ) {
      Jikkoku::Class::BattleMode::Exception
        ->throw($self->name . 'は攻城戦では使えません');
    }
    $self->$orig($battle_service);
  };

  sub adjust_attack_power {
    my ($self, $chara_power_adjuster_service) = @_;
    my ($chara, $enemy) = ($self->chara, $chara_power_adjuster_service->target);
    if ( $enemy->soldier->num <= ENEMY_SOLDIER_NUM ) {
      if ( $chara->soldier->num > $enemy->soldier->num ) {
        int( ($chara->soldier->num - $enemy->soldier->num) * INCREASE_ATTACK_POWER_RATIO );
      } else {
        0;
      }
    } else {
      0;
    }
  }

  __PACKAGE__->meta->make_immutable;

}

1;

