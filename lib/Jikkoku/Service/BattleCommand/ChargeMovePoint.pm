package Jikkoku::Service::BattleCommand::ChargeMovePoint {

  use Mouse;
  use Jikkoku;

  use Jikkoku::Model::Config;
  my $CONFIG = Jikkoku::Model::Config->get;

  has 'move_point_charge_time' => (
    is      => 'rw',
    isa     => 'Int',
    default => $CONFIG->{game}{action_interval_time},
  );

  with qw( Jikkoku::Service::BattleCommand::BattleCommand );

  sub ensure_can_exec {
    my $self = shift;
    my $sub  = $self->chara->soldier_battle_map('move_point_charge_time') - $self->time;
    if ($sub > 0) {
      Jikkoku::Service::Role::BattleActionException->throw("あと $sub 秒移動Pは補充できません。");
    }
  }

  sub exec {
    my $self = shift;
    my $chara = $self->chara;
    
    $chara->lock;
    eval {
      $self->chara_soldier->charge_move_point( $self->time + $self->move_point_charge_time );
    };
    if (my $e = $@) {
      $chara->abort;
      if ( Jikkoku::Exception->caught($e) ) {
        $e->rethrow;
      } else {
        die $e;
      }
    } else {
      $chara->commit;
    }

  }

  __PACKAGE__->meta->make_immutable;

}

1;
