package Jikkoku::Service::Skill::Command::Close {

  use Mouse;
  use Jikkoku;

  with 'Jikkoku::Service::BattleCommand::Battle::BattleLoop::EventExecuteService';

  # 攻城戦のとき、発動率低下
  around occur_ratio => sub {
    my ($orig, $self) = @_;
    if ( $self->battle_loop->is_siege ) {
      $self->$orig() / $self->event_executer->NUM_OF_DIVIDE_OCCUR_RATIO_WHEN_SIEGE;
    } else {
      $self->$orig();
    }
  };

  sub calc_state_count {
    my ($self, $before_state_count) = @_;
    my $event_executer = $self->event_executer;
    if ( $before_state_count < $event_executer->INCREASE_DEFENCE_POWER_LIMIT ) {
      my $temp_state_count = $before_state_count + $event_executer->INCREASE_DEFENCE_POWER;
      $temp_state_count > $event_executer->INCREASE_DEFENCE_POWER_LIMIT
        ? $event_executer->INCREASE_DEFENCE_POWER_LIMIT
        : $temp_state_count;
    } else {
      $before_state_count;
    }
  }

  sub exec_event {
    my $self = shift;
    my $event_executer = $self->event_executer;

    my $state = $self->chara->states->get('IncreaseDefencePower');
    my $before_count = $state->count;
    my $state_count  = $self->calc_state_count($before_count);
    $state->set_state_for_chara({count => $state_count});
    # 守備力が変わるため
    $self->battle_loop->update_orig_max_take_damage();
    my $increase_power = $state_count - $before_count;

    my $log = sub {
      my $color = shift;
      qq{<span class="$color">【@{[ $event_executer->name ]} 】</span>}
        . qq{@{[ $self->chara->name ]}の部隊が@{[ $event_executer->name ]}しました！ }
        . qq{@{[ $self->chara->name ]}の守備力が<span class="red">+${increase_power}されました。};
    };
    $self->chara->battle_logger->add( $log->('red') );
    $self->target->battle_logger->add( $log->('blue') );
  }

  __PACKAGE__->meta->make_immutable;

}

1;

