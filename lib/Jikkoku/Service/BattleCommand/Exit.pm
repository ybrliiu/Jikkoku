package Jikkoku::Service::BattleCommand::Exit {

  use Mouse;
  use Jikkoku;

  use Jikkoku::Model::Config;
  use Jikkoku::Model::Unite;

  my $CONFIG = Jikkoku::Model::Config->get;

  with 'Jikkoku::Service::BattleCommand::PassCheckPoint';

  sub ensure_can_exec_about_target_town {
    my $self = shift;
    if (
      $self->chara->is_neutral         &&
      !$self->target_town->is_neutral  &&
      !Jikkoku::Model::Unite->is_unite
    ) {
      Jikkoku::Service::Role::BattleActionException
        ->throw('無所属武将は無所属都市以外の都市へ向けて出兵することはできません。(統一後は可能)');
    }
  }

  around exec_log => sub {
    my ($orig, $self) = (shift, shift);
    $self->$orig(@_) . 'へ向けて出城しました！';
  };

  around occur_stop_around_time => sub {
    my ($orig, $self) = (shift, shift);
    my $before_town = $self->town_model->get( $self->battle_map->id );
    if (
      $before_town->is_occur_stop_around_time                    &&
      $before_town->country_id != $self->chara->country_id       &&
      $before_town->country_id == $self->target_town->country_id
    ) {
      my ($elapsed_year, $interval_time) = ($self->now_game_date->elapsed_year, $CONFIG->{game}{action_interval_time});
      my $set_move_time = $before_town->stop_around_move_time( $elapsed_year, $interval_time );
      my $set_action_time = $before_town->stop_around_action_time( $elapsed_year, $interval_time );
      $self->chara->soldier->occur_action_time( $self->time + $set_action_time );
      $self->chara->soldier->occur_move_point_charge_time( $self->time + $set_move_time );
    }
  };

  __PACKAGE__->meta->make_immutable;

}

1;
