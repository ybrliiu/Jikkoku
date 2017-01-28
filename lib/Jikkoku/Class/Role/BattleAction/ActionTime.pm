package Jikkoku::Class::Role::BattleAction::ActionTime {

  use Moo::Role;
  use Jikkoku;

  before ensure_can_action => sub {
    my ($self, @args) = @_;
    my $time = time;
    if ( $self->chara->soldier_battle_map('action_time') > $time ) {
      my $wait_time = $self->chara->soldier_battle_map('action_time') - $time;
      throw("あと $wait_time 秒行動できません。\n");
    }
  };

}

1;
