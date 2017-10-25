package Jikkoku::Service::Skill::BattleMethod::SacrificeAttack {

  use Mouse;
  use Jikkoku;

  use constant MAX_SACRIFICE_SOLDIER => 9;

  with 'Jikkoku::Service::BattleCommand::Battle::BattleLoop::EventExecuteService';

  around can_exec_event => sub {
    my ($orig, $self) = @_;
    # 兵士1人以下の時は自滅してしまうので発動させない
    $self->$orig() && $self->chara->soldier->num > 1;
  };

  sub exec_event {
    my $self = shift;

    my $sacrifice_soldier = do {
      # 兵士が1人以下になって自滅しないように
      my $sacrifice_soldier = int(rand MAX_SACRIFICE_SOLDIER) + 1;
      my $lack = $self->soldier->num - $sacrifice_soldier;
      if ($lack < 1) {
        $sacrifice_soldier += $lack + 1;
      }
      $sacrifice_soldier;
    };
    my $damage = $sacrifice_soldier *
      ( $self->battle_loop->is_siege
        ? $self->event_executer->take_damage_ratio_on_siege
        : $self->event_executer->take_damage_ratio_on_siege );

    $self->chara->soldier->minus_equal($sacrifice_soldier);
    $self->target->soldier->minus_equal($damage);

    my $log = sub {
      my $color = shift;
      qq{<span class="$color">【@{[ $self->event_executer->name ]} 】</span>@{[ $self->chara->name ]}は自軍の兵士を犠牲にし、@{[ $self->event_executer->name ]}を仕掛けました！ @{[ $self->chara->soldier_status ]} ↓(-${sacrifice_soldier}) | @{[ $self->target->soldier_status ]} ↓(-${damage})};
    };
    $self->chara->battle_logger->add( $log->('red') );
    $self->target->battle_logger->add( $log->('blue') );

  }

  __PACKAGE__->meta->make_immutable;

}

1;

