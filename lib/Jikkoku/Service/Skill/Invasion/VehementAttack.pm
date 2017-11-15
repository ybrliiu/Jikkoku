package Jikkoku::Service::Skill::Invasion::VehementAttack {

  use Mouse;
  use Jikkoku;

  use constant MAX_DAMAGE => 8;

  with 'Jikkoku::Service::BattleCommand::Battle::BattleLoop::EventExecuteService';

  # 攻城戦のとき、発動率1/2
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
    my ($chara, $target) = ($self->chara, $self->target);

    my $state              = $chara->states->get('IncreaseAttackPower');
    my $before_state_count = $state->count;
    my $state_count        = $self->calc_state_count($before_state_count);
    $state->set_state_for_chara({count => $state_count});
    # 攻撃力が変わるため
    $self->battle_loop->update_orig_max_take_damage();

    my $increase_power = $state_count - $before_state_count;
    my $damage = int(rand MAX_DAMAGE) + 1;
    $target->soldier->minus_equal($damage);

    my $log = sub {
      my $color = shift;
      my $attack_power_mes = $increase_power > 0
        ? qq{@{[ $chara->name ]}の攻撃力が+<span class="red">${increase_power}</span>されました！}
        : '';
      qq{<span class="$color">【@{[ $self->event_executer->name ]} 】</span>}
        . qq{@{[ $chara->name ]}は@{[ $target->name ]}の部隊を激しく攻め立てています！}
        . qq{${attack_power_mes} @{[ $target->soldier_status ]} ↓(-${damage})};
    };
    $chara->battle_logger->add( $log->('red') );
    $target->battle_logger->add( $log->('blue') );
  }

  __PACKAGE__->meta->make_immutable;

}

1;

