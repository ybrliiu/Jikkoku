package Jikkoku::Service::Skill::Command::Offensive {

  use Mouse;
  use Jikkoku;

  use constant MAX_TAKE_DAMAGE => 4;

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
    if ( $before_state_count < $event_executer->INCREASE_ATTACK_POWER_LIMIT ) {
      my $temp_state_count = $before_state_count + $event_executer->INCREASE_ATTACK_POWER;
      $temp_state_count > $event_executer->INCREASE_ATTACK_POWER_LIMIT
        ? $event_executer->INCREASE_ATTACK_POWER_LIMIT
        : $temp_state_count;
    } else {
      $before_state_count;
    }
  }

  sub exec_event {
    my $self = shift;
    my $event_executer = $self->event_executer;

    my $state = $self->chara->states->get('IncreaseAttackPower');
    my $before_count = $state->count;
    my $state_count  = $self->calc_state_count($before_count);
    $state->set_state_for_chara({count => $state_count});
    $self->battle_loop->update_orig_max_take_damage();
    my $increase_power = $state_count - $before_count;

    my $damage = int(rand MAX_TAKE_DAMAGE) + 1;
    $self->target->soldier->minus_equal($damage);

    my $log = sub {
      my $color = shift;
      qq{<span class="$color">【@{[ $event_executer->name ]} 】</span>}
        . qq{@{[ $self->chara->name ]}が@{[ $event_executer->name ]}を行いました！ }
        . qq{@{[ $self->chara->name ]}の攻撃力が<span class="red">+${increase_power} }
        . qq{@{[ $self->target->soldier_status ]} ↓(-${damage})};
    };
    $self->chara->battle_logger->add( $log->('red') );
    $self->target->battle_logger->add( $log->('blue') );
  }

  __PACKAGE__->meta->make_immutable;

}

1;

