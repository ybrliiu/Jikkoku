package Jikkoku::Class::BattleCommand::ChargeMovePoint {

  use v5.14;
  use warnings;
  use Role::Tiny::With;
  use parent 'Jikkoku::Class::BattleCommand::Base';
  with 'Jikkoku::Class::Role::BattleAction';

  sub ensure_can_action {
    my ($self) = @_;
    my $time = time;
    if ( $self->{chara}->soldier_battle_map('move_point_charge_time') > $time ) {
      my $wait_time = $self->{chara}->soldier_battle_map('move_point_charge_time') - $time;
      die "あと $wait_time 秒補充できません。\n";
    }
  }

  sub action {
    my ($self) = @_;

    eval {
      $self->{chara}->charge_move_point;
      $self->{chara}->occur_move_point_charge_time;
    };

    if (my $e = $@) {
      $self->{chara}->abort;
      die " $@ \n";
    }

  }

}

1;
