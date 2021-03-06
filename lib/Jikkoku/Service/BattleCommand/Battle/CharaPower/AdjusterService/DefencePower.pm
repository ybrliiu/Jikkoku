package Jikkoku::Service::BattleCommand::Battle::CharaPower::AdjusterService::DefencePower {

  use Mouse;
  use Jikkoku;

  with 'Jikkoku::Service::BattleCommand::Battle::CharaPower::AdjusterService::CharaPower';

  has 'adjuster' => (
    is       => 'ro',
    does     => 'Jikkoku::Service::BattleCommand::Battle::CharaPower::DefencePowerAdjuster',
    required => 1,
  );

  has 'orig_attack_power'  => ( is => 'ro', isa => 'Num', required => 0 );

  around _build_adjust_attack_power=> sub { 0 };

  sub write_to_log {
    my $self = shift;
    my $log = sub {
      my $color = shift;
      qq{<span class="$color">【@{[ $self->adjuster->name ]}】</span>@{[ $self->chara->name ]}の}
      . qq{守備力が<span class="$color">@{[ sign($self->adjust_defence_power) ]}@{[ $self->adjust_defence_power ]}</span>されました。};
    };
    $self->chara->battle_logger->add( $log->('red') );
    $self->target->battle_logger->add( $log->('blue') );
  }

  __PACKAGE__->meta->make_immutable;

}

1;

