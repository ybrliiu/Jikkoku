package Jikkoku::Service::Skill::Command::Charge {

  use Mouse;
  use Jikkoku;

  use constant MAX_TAKE_DAMAGE => 6;

  with 'Jikkoku::Service::BattleCommand::Battle::BattleLoop::EventExecuteService';

  sub exec_event {
    my $self = shift;
    my $damage = int(rand MAX_TAKE_DAMAGE) + 1;
    $self->target->soldier->minus_equal($damage);
    my $log = sub {
      my $color = shift;
      qq{<span class="$color">【@{[ $self->event_executer->name ]} 】</span>}
        . qq{@{[ $self->chara->name ]}の部隊は敵部隊に突撃しました！ @{[ $self->target->soldier_status ]} ↓(-${damage})};
    };
    $self->chara->battle_logger->add( $log->('red') );
    $self->target->battle_logger->add( $log->('blue') );
  }

  __PACKAGE__->meta->make_immutable;

}

1;

