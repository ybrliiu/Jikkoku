package Jikkoku::Service::Skill::BattleMethod::DestroyAttack {

  use Mouse;
  use Jikkoku;

  use constant TAKE_DAMAGE_NUM => 15;

  with 'Jikkoku::Service::BattleCommand::Battle::BattleLoop::EventExecuteService';

  sub exec_event {
    my $self = shift;
    $self->target->soldier->minus_equal(TAKE_DAMAGE_NUM);
    my $log = sub {
      my $color = shift;
      qq{<span class="$color">【@{[ $self->event_executer->name ]} 】</span>}
        . qq{@{[ $self->chara->name ]}が@{[ $self->event_executer->name ]}を行いました。}
        . qq{@{[ $self->target->name ]}の部隊は甚大な被害を受けました。 @{[ $self->target->soldier_status ]} ↓(-@{[ TAKE_DAMAGE_NUM ]})};
    };
    $self->chara->battle_logger->add( $log->('red') );
    $self->target->battle_logger->add( $log->('blue') );
  }

  __PACKAGE__->meta->make_immutable;

}

1;

