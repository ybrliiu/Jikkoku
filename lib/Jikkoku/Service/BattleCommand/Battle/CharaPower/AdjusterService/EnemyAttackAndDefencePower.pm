package Jikkoku::Service::BattleCommand::Battle::CharaPower::AdjusterService::EnemyAttackAndDefencePower {

  use Mouse;
  use Jikkoku;

  has 'adjuster' => (
    is       => 'ro',
    does     => 'Jikkoku::Service::BattleCommand::Battle::CharaPower::EnemyAttackAndDefencePowerAdjuster',
    required => 1,
  );

  with 'Jikkoku::Service::BattleCommand::Battle::CharaPower::AdjusterService::EnemyPower';

  sub write_to_log {
    my $self = shift;
    my $log = sub {
      my $color = shift;
      qq{<span class="$color">【@{[ $self->adjuster->name ]}】</span>@{[ $self->chara->name ]}の}
      . qq{攻撃力が<span class="$color">@{[ sign($self->adjust_enemy_attack_power) ]}@{[ $self->adjust_enemy_attack_power ]}</span>、}
      . qq{守備力が<span class="$color">@{[ sign($self->adjust_enemy_defence_power) ]}@{[ $self->adjust_enemy_defence_power ]}</span>されました。};
    };
    $self->chara->battle_logger->add( $log->('red') );
    $self->target->battle_logger->add( $log->('blue') );
  }

  __PACKAGE__->meta->make_immutable;

}

1;

