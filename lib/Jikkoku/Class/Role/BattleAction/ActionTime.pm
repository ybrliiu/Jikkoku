package Jikkoku::Class::Role::BattleAction::ActionTime {

  use Jikkoku;
  use Role::Tiny;
  use Role::Tiny::With;
  with 'Jikkoku::Class::Role::BattleAction';

  requires qw/ensure_can_action action/;

  before ensure_can_action => sub {
    my ($self, @args) = @_;
    my $time = time;
    if ( $self->{chara}->soldier_battle_map('action_time') > $time ) {
      my $wait_time = $self->{chara}->soldier_battle_map('action_time') - $time;
      throw("あと $wait_time 秒行動できません。\n");
    }
  };

}

1;
