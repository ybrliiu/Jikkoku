package Jikkoku::Service::BattleCommand::Battle::CharaPower::AdjusterService::EnemyAttackPower {

  use Mouse;
  use Jikkoku;

  has 'adjuster' => (
    is       => 'ro',
    does     => 'Jikkoku::Service::BattleCommand::Battle::CharaPower::EnemyAttackPowerAdjuster',
    required => 1,
  );

  has 'orig_enemy_defence_power' => ( is => 'ro', isa => 'Int', required => 0 );

  with 'Jikkoku::Service::BattleCommand::Battle::CharaPower::AdjusterService::EnemyPower';

  around _build_adjust_enemy_defence_power => sub { 0 };

  sub write_to_log {
    my $self = shift;
    my $log = sub {
      my $color = shift;
      qq{<span class="$color">【@{[ $self->adjuster->name ]}】</span>@{[ $self->chara->name ]}の}
      . qq{攻撃力が<span class="$color">@{[ sign($self->adjust_enemy_attack_power) ]}@{[ $self->adjust_enemy_attack_power ]}</span>されました。};
    };
    $self->chara->battle_logger->add( $log->('red') );
    $self->target->battle_logger->add( $log->('blue') );
  }
  __PACKAGE__->meta->make_immutable;

}

1;

