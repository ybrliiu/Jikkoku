package Jikkoku::Service::BattleCommand::Battle::TurnAdjusterService {

  use Mouse;
  use Jikkoku;
  use Jikkoku::Util qw( sign );

  has [qw/ chara target /] => (
    is       => 'ro',
    isa      => 'Jikkoku::Class::Chara::ExtChara',
    required => 1,
  );

  has 'adjuster' => (
    is       => 'ro',
    does     => 'Jikkoku::Service::BattleCommand::Battle::TurnAdjuster',
    handles  => [qw/ adjust_battle_turn /],
    required => 1,
  );

  sub write_to_log {
    my $self = shift;
    my $log = sub {
      my $color = shift;
      qq{<span class="$color">【@{[ $self->adjuster->name ]}】</span>@{[ $self->chara->name ]}の}
      . qq{効果により、ターン数が<span class="$color">@{[ sign($self->adjust_battle_turn) ]}@{[ $self->adjust_battle_turn ]}</span>されました。};
    };
    $self->chara->battle_logger->add( $log->('red') );
    $self->target->battle_logger->add( $log->('blue') );
  }

  __PACKAGE__->meta->make_immutable;

}

1;

