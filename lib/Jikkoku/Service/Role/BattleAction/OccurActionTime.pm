package Jikkoku::Service::Role::BattleAction::OccurActionTime {

  use Mouse::Role;
  use Jikkoku;

  before ensure_can_exec => sub {
    my $self = shift;
    if ( $self->chara_soldier->action_time > $self->time ) {
      my $wait_time = $self->chara_soldier->action_time - $self->time;
      Jikkoku::Service::Role::BattleActionException->throw("あと $wait_time 秒行動できません。\n");
    }
  };

}

1;
