package Jikkoku::Service::Skill::BattleMethod::KeisuAttack {

  use Mouse;
  use Jikkoku;

  with 'Jikkoku::Service::BattleCommand::Battle::BattleLoop::EventExecuteService';

  sub exec_event {
    my $self = shift;
    my $state  = $self->chara->states->get('KeisuCount');
    my $damage = $state->count + $self->event_executer->PLUS_TAKE_DAMAGE;
    $self->target->soldier->minus_equal($damage);
    my $log = sub {
      my $color = shift;
      qq{<span class="$color">【@{[ $self->event_executer->name ]} 】</span>}
        . qq{@{[ $self->chara->name ]}が@{[ $self->event_executer->name ]}を仕掛けました。 @{[ $self->target->soldier_status ]} ↓(-${damage})};
    };
    $self->chara->battle_logger->add( $log->('red') );
    $self->target->battle_logger->add( $log->('blue') );
    if ( $state->count < $self->event_executer->INCREASE_DAMAGE_LIMIT ) {
      $state->set_state_for_chara({count => $state->count + 1});
    }
  }

  __PACKAGE__->meta->make_immutable;

}

1;

