package Jikkoku::Class::Role::BattleAction::OccurActionTime {

  use Mouse::Role;
  use Jikkoku;

  has 'time' => (
    is      => 'ro',
    isa     => 'Num',
    lazy    => 1,
    default => sub { time },
  );

  before ensure_can_exec => sub {
    my $self = shift;
    if ( $self->chara->soldier_battle_map('action_time') > $self->time ) {
      my $wait_time = $self->chara->soldier_battle_map('action_time') - $self->time;
      Jikkoku::Class::Role::BattleActionException->throw("あと $wait_time 秒行動できません。\n");
    }
  };

}

1;
