package Jikkoku::Service::BattleCommand::Battle::CharaPower::AdjusterService::AttackPower {

  use Mouse;
  use Jikkoku;

  has 'adjuster' => (
    is       => 'ro',
    does     => 'Jikkoku::Service::BattleCommand::Battle::CharaPower::AttackPowerAdjuster',
    required => 1,
  );

  with 'Jikkoku::Service::BattleCommand::Battle::CharaPower::AdjusterService::CharaPower';

  has 'orig_defence_power'  => ( is => 'ro', isa => 'Int', required => 0 );

  around _build_adjust_defence_power => sub { 0 };

  sub write_to_log {
    my $self = shift;
    my $log = sub {
      my $color = shift;
      qq{<span class="$color">【@{[ $self->adjuster->name ]}】</span>@{[ $self->chara->name ]}の}
      . qq{攻撃力が<span class="$color">@{[ sign($self->adjust_attack_power) ]}@{[ $self->adjust_attack_power ]}</span>されました。};
    };
    $self->chara->battle_logger->add( $log->('red') );
    $self->target->battle_logger->add( $log->('blue') );
  }

  __PACKAGE__->meta->make_immutable;

}

1;

