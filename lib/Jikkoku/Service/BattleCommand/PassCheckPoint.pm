package Jikkoku::Service::BattleCommand::PassCheckPoint {

  use Mouse::Role;
  use Jikkoku;

  use Jikkoku::Model::Config;
  my $CONFIG = Jikkoku::Model::Config->get;

  with qw(
    Jikkoku::Service::Role::BattleAction
    Jikkoku::Service::BattleCommand::BattleCommand
  );

  requires qw( ensure_can_exec_about_target_town );

  has 'check_point_x' => ( is => 'ro', isa => 'Int', required => 1 );
  has 'check_point_y' => ( is => 'ro', isa => 'Int', required => 1 );

  has 'battle_map_model' => (
    is      => 'ro',
    isa     => 'Jikkoku::Model::BattleMap',
    lazy    => 1,
    default => sub {
      my $self = shift;
      $self->model('BattleMap')->new;
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

  has 'town_model' => (
    is      => 'ro',
    isa     => 'Jikkoku::Model::Town',
    lazy    => 1,
    default => sub {
      my $self = shift;
      $self->model('Town')->new;
    },
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

  has 'country_model' => (
    is      => 'ro',
    isa     => 'Jikkoku::Model::Country',
    lazy    => 1,
    default => sub {
      my $self = shift;
      $self->model('Country')->new;
    },
  );

  has 'chara_model' => (
    is      => 'ro',
    isa     => 'Jikkoku::Model::Chara',
    lazy    => 1,
    default => sub {
      my $self = shift;
      $self->model('Chara')->new;
    },
  );

  has 'map_log_model' => (
    is      => 'ro',
    isa     => 'Jikkoku::Model::MapLog',
    lazy    => 1,
    default => sub {
      my $self = shift;
      $self->model('MapLog')->new;
    },
  );

  has 'now_game_date' => (
    is      => 'ro',
    isa     => 'Jikkoku::Class::GameDate',
    lazy    => 1,
    default => sub {
      my $self = shift;
      $self->model('GameDate')->new->get;
    },
  );

  has 'entry_check_point' => (
    is  => 'rw',
    isa => 'Jikkoku::Class::BattleMap::CheckPoint',
  );

  sub ensure_can_exec {
    my $self = shift;

    my $entry_node = $self->battle_map->get_node_by_point(
      $self->check_point_x,
      $self->check_point_y,
    );
    unless ( $entry_node->is_check_point ) {
      Jikkoku::Class::Role::BattleActionException
        ->throw('指定された座標からは関所の出入りはできません。');
    }
    $self->entry_check_point( $entry_node->check_point );

    unless ( $self->chara_soldier->distance_from($entry_node) < 1 ) {
      Jikkoku::Class::Role::BattleActionException
        ->throw('関所の上、または隣接するマスにいません。');
    }

    my $has_enemies_on_the_position = $self->chara_model
      ->get_all_with_result
      ->get_not_applicable_charactors_by_country_id_with_result( $self->chara->country_id )
      ->get_charactors_by_soldier_bm_id_with_result( $self->chara_soldier->battle_map_id )
      ->get_charactors_by_soldier_point_with_result( $entry_node );
    if (@$has_enemies_on_the_position) {
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
      my $soldier                 = $self->chara_soldier;
      my $target_bm               = $self->battle_map_model->get( $self->entry_check_point->target_bm_id );
      my $destination_check_point = $target_bm->get_check_point_by_target_bm_id( $soldier->battle_map_id );
      $soldier->move_battle_map( $target_bm->id, $destination_check_point );
      my $before_town = $self->town_model->get_by_name( $destination_check_point->target_town_name );
      $soldier->add_action_time( $self->time + $CONFIG->{game}{action_interval_time} );
      $self->occur_stop_around_time;
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
      my $log = $self->exec_log;
      $chara->save_battle_log($log);
      $chara->save_command_log($log);
      $self->map_log_model->add($log)->save;
    }

  }

}

1;
