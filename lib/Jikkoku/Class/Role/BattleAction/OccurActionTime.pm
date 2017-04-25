package Jikkoku::Class::Role::BattleAction::OccurActionTime {

  use Mouse::Role;
  use Jikkoku;

  before ensure_can_exec => sub {
    my ($self, $args) = @_;
    $args->{time} //= time();
    if ( $self->chara->soldier_battle_map('action_time') > $args->{time} ) {
      my $wait_time = $self->chara->soldier_battle_map('action_time') - $args->{time};
      Jikkoku::Class::Role::BattleActionException->throw("あと $wait_time 秒行動できません。\n");
    }
  };

}

1;
