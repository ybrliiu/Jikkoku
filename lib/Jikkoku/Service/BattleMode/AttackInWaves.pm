package Jikkoku::Service::BattleMode::AttackInWaves {

  use Mouse;
  use Jikkoku;

  with 'Jikkoku::Service::BattleCommand::Battle::BattleLoop::EventExecuteService';

  sub exec_event {
    my $self = shift;
    my $damage = (int(rand 5) + 1) * 2;
    $self->target->soldier->minus_equal($damage);
    my $log = sub {
      my $color = shift;
      qq{<span class="$color">【@{[ $self->event_executer->name ]} 】</span>}
        . qq{@{[ $self->chara->name ]}が@{[ $self->event_executer->name ]}を仕掛けた！ }
        . qq{@{[ $self->target->name ]}の部隊は損害を受けました。 @{[ $self->target->soldier_status ]} ↓(-${damage})};
    };
    $self->chara->battle_logger->add( $log->('red') );
    $self->target->battle_logger->add( $log->('blue') );
  }

  __PACKAGE__->meta->make_immutable;

}

1;

