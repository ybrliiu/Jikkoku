package Jikkoku::Class::BattleCommand::PassCheckPoint {

  use Mouse::Role;
  use Jikkoku;
  use Jikkoku::Util 'validate_values';

  use Jikkoku::Model::Config;
  use Jikkoku::Model::Unite;
  use Jikkoku::Model::GameDate;

  my $CONFIG = Jikkoku::Model::Config->get;

  with qw(
    Jikkoku::Class::BattleCommand::BattleCommand
    Jikkoku::Class::Role::BattleAction
  );

  requires qw( ensure_can_exec_about_target_town );

  has 'chara_soldier' => (
    is      => 'ro',
    isa     => 'Jikkoku::Class::Chara::Soldier',
    lazy    => 1,
    default => sub {
      my $self = shift;
      $self->chara->soldier;
    },
  );

  has 'battle_map' => (
    is      => 'ro',
    isa     => 'Jikkoku::Class::BattleMap',
    lazy    => 1,
    default => sub {
      my $self = shift;
      $self->battle_map_model->get( $self->chara_soldier->battle_map_id );
    },
  );

  has 'entry_check_point' => (
    is  => 'rw',
    isa => 'Jikkoku::Class::BattleMap::CheckPoint',
  );

  has 'target_town' => (
    is      => 'ro',
    isa     => 'Jikkoku::Class::Town',
    lazy    => 1,
    default => sub {
      my $self = shift;
      $self->town_model->get_by_name( $self->entry_check_point->target_town_name );
    },
  );

  has 'time' => (
    is      => 'ro',
    isa     => 'Num',
    lazy    => 1,
    default => sub { time },
  );

  has 'now_game_date' => (
    is      => 'ro',
    isa     => 'Jikkoku::Class::GameDate',
    lazy    => 1,
    default => sub { Jikkoku::Model::GameDate->new->get },
  );

  has 'battle_map_model' => ( is => 'rw', isa => 'Jikkoku::Model::BattleMap' );
  has 'town_model'       => ( is => 'rw', isa => 'Jikkoku::Model::Town' );
  has 'country_model'    => ( is => 'rw', isa => 'Jikkoku::Model::Country' );
  has 'map_log_model'    => ( is => 'rw', isa => 'Jikkoku::Model::MapLog' );

  sub ensure_can_exec {
    my ($self, $args) = @_;
    validate_values $args => [qw/
      check_point_x check_point_y
      battle_map_model town_model chara_model country_model map_log_model
    /];

    $self->$_( $args->{$_} ) for qw( battle_map_model town_model country_model map_log_model );

    my $entry_node = $self->battle_map->get_node_by_point( $args->{check_point_x}, $args->{check_point_y} );
    unless ( $entry_node->is_check_point ) {
      Jikkoku::Class::Role::BattleActionException->throw('指定された座標からは関所の出入りはできません。');
    }
    $self->entry_check_point( $entry_node->check_point );

    unless ( $self->chara_soldier->distance_from($entry_node) < 1 ) {
      Jikkoku::Class::Role::BattleActionException->throw('関所の上、または隣接するマスにいません。');
    }

    my $has_enemies_on_the_position = $args->{chara_model}->has_enemies_on_the_position({
      country_id    => $self->chara->country_id,
      battle_map_id => $self->battle_map->id,
      point         => $entry_node,
    });
    if ($has_enemies_on_the_position) {
      Jikkoku::Class::Role::BattleActionException->throw('関所の上に敵がいます。');
    }

    $self->ensure_can_exec_about_target_town;
  }

  sub exec_log {
    my $self = shift;
    my $country = $self->country_model->get_with_option( $self->chara->country_id )->get;
    "@{[ $self->now_game_date->month ]}月 : @{[ $country->name ]}の@{[ $self->chara->name ]}は"
    . "@{[ $self->entry_check_point->target_town_name ]}に入城しました！";
  }

  sub occur_stop_around_time {}

  sub exec {
    my $self = shift;

    my $chara = $self->chara;
    $chara->lock;

    eval {
      my $soldier = $self->chara_soldier;
      my $target_bm = $self->battle_map_model->get( $self->entry_check_point->target_bm_id );
      my $destination_check_point = $target_bm->get_check_point_by_target_bm_id( $soldier->battle_map_id );
      $soldier->move_battle_map( $target_bm->id, $destination_check_point );
      my $before_town = $self->town_model->get_by_name( $destination_check_point->target_town_name );
      $soldier->add_action_time( $self->time + $CONFIG->{game}{action_interval_time} );
      $self->occur_stop_around_time;
    };

    if (my $e = $@) {
      $chara->abort;
      if ( Exception::Tiny->caught($e) ) {
        $e->rethrow;
      } else {
        die $e;
      }
    } else {
      $chara->commit;
      my $log = $self->exec_log;
      $chara->save_battle_log($log);
      $chara->save_command_log($log);
      $self->map_log_model->add($log)->save;
    }

  }

}

1;
