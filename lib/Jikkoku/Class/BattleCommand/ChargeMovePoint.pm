package Jikkoku::Class::BattleCommand::ChargeMovePoint {

  use Mouse;
  use Jikkoku;

  use Jikkoku::Model::Config;
  my $CONFIG = Jikkoku::Model::Config->get;

  has 'move_point_charge_time' => (is => 'rw', default => $CONFIG->{game}{action_interval_time});

  with qw(
    Jikkoku::Class::BattleCommand::BattleCommand
    Jikkoku::Class::Role::BattleAction
  );

  sub ensure_can_action {
    my $self = shift;
    my $time = time;
    my $sub  = $self->chara->soldier_battle_map('move_point_charge_time') - $time;
    throw("あと $sub 秒移動Pは補充できません。") if $sub > 0;
    $time;
  }

  sub action {
    my ($self, $time) = @_;
    my $chara = $self->chara;
    
    $chara->lock;

    eval {
      $chara->soldier_battle_map( move_point => $self->chara->soldier->move_point );
      $chara->soldier_battle_map( move_point_charge_time => $time + $self->move_point_charge_time );
    };

    if (my $e = $@) {
      $chara->abort;
      throw($e);
    } else {
      $chara->commit;
    }

  }

  __PACKAGE__->meta->make_immutable;

}

1;
