package Jikkoku::Service::Skill::Invasion::VehementAttack {

  use Mouse;
  use Jikkoku;

  use constant MAX_DAMAGE => 8;

  with 'Jikkoku::Service::BattleCommand::Battle::BattleLoop::EventExecuteService';

  # 攻城戦のとき、発動率1/2
  around occur_ratio => sub {
    my ($orig, $self) = @_;
    $self->$orig() / $self->event_executer->NUM_OF_DIVIDE_OCCUR_RATIO_WHEN_SIEGE;
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

    my $increase_power  = $state_count - $before_state_count;
    my $increase_damage = int $increase_power / 10;
    # $chara->orig_max_take_damage が $chara->ADJUST_MAX_TAKE_DAMAGE 以下の時の処理
    # 単純に $chara->max_take_damage を上げてしまうと
    # 本来なら攻撃力を上げたところで相手の守備力を超えれないはずなのにダメージを与れてしまう
    # それを防ぐための処理
    # $chara->orig_max_take_damage < $chara->ADJUST_MAX_TAKE_DAMAGE のとき $chara->max_take_damage = $chara->ADJUST_MAX_TAKE_DAMAGE
    if ( $chara->orig_max_take_damage < $chara->ADJUST_MAX_TAKE_DAMAGE ) {
      $chara->orig_max_take_damage( $chara->orig_max_take_damage + $increase_damage );
      # $chara->max_take_damage が $chara->ADJUST_MAX_TAKE_DAMAGE を超えて初めて $chara->max_take_damage の増加が許される
      # そしてその状況では $chara->max_take_damage == $chara->orig_max_take_damage 
      if ( $chara->orig_max_take_damage > $chara->ADJUST_MAX_TAKE_DAMAGE ) {
        $chara->max_take_damage( $chara->orig_max_take_damage );
      }
    }
    # ここに来るときには必ず
    # $chara->orig_max_take_damage >= $chara->ADJUST_MAX_TAKE_DAMAGE && $chara->max_take_damage >= $chara->ADJUST_MAX_TAKE_DAMAGE
    else {
      $chara->max_take_damage( $chara->max_take_damage + $increase_damage );
    }

    my $damage = int(rand MAX_DAMAGE) + 1;
    $target->soldier->minus_equal($damage);

    my $log = sub {
      my $color = shift;
      qq{<span class="$color">【@{[ $self->event_executer->name ]} 】</span>}
        . qq{@{[ $chara->name ]}は@{[ $target->name ]}の部隊を激しく攻め立てています！}
        . qq{@{[ $chara->name ]}の攻撃力が+<span class="red">${increase_power}</span>}
        . qq{されました！ @{[ $target->soldier_status ]} ↓(-${damage})};
    };
    $chara->battle_logger->add( $log->('red') );
    $target->battle_logger->add( $log->('blue') );
  }

  __PACKAGE__->meta->make_immutable;

}

1;

