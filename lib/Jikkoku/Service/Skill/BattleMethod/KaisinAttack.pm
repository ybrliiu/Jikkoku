package Jikkoku::Service::Skill::BattleMethod::KaisinAttack {

  use Mouse;
  use Jikkoku;

  with 'Jikkoku::Service::BattleCommand::Battle::BattleLoop::EventExecuteService';

  sub exec_event {
    my $self = shift;
    $self->chara->take_damage( int $self->chara->take_damage * $self->event_executer->increase_damage_ratio );
    my $log = sub {
      my $color = shift;
      qq{<span class="$color">【@{[ $self->event_executer->name ]} 】</span>}
        . qq{@{[ $self->chara->name ]}が@{[ $self->event_executer->name ]}を仕掛けました。}
        . qq{@{[ $self->chara->name ]}の与えるダメージが@{[ $self->event_executer->increase_damage_ratio ]}倍になります。};
    };
    $self->chara->battle_logger->add( $log->('red') );
    $self->target->battle_logger->add( $log->('blue') );
  }

  __PACKAGE__->meta->make_immutable;

}

1;

