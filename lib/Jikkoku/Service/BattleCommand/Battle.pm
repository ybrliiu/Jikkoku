package Jikkoku::Service::BattleCommand::Battle {

  use Mouse;
  use Jikkoku;
  use Option;
  use Jikkoku::Model::Config;

  use constant {
    CONFUSED_BATTLE_RANGE => 1,
  };

  # battle result
  use constant {
    NONE => 0,
    WIN  => 1,
    LOSE => 2,
    DRAW => 3,
  };

  my $CONFIG = Jikkoku::Model::Config->get;

  has 'traget_id' => ( is => 'ro', isa => 'Str', required => 1 );

  has 'target' => (
    is      => 'ro',
    isa     => 'Jikkoku::Class::Chara::ExtChara',
    lazy    => 1,
    builder => '_build_target',
  );

  has 'charactors' => (
    is      => 'ro',
    isa     => 'Jikkoku::Model::Chara::Result',
    lazy    => 1,
    default => sub {
      my $self = shift;
      $self->chara_model->get_all_with_result;
    },
  );

  for my $name (qw/ chara town country diplomacy /) {
    my $class_name = ucfirst $name;
    has "${name}_model" => (
      is      => 'ro',
      isa     => "Jikkoku::Model::$class_name",
      lazy    => 1,
      default => sub { $_[0]->model($class_name)->new },
    );
  }

  has 'chara_battle_log_model' => (
    is      => 'ro',
    isa     => 'Jikkoku::Model::Chara::BattleLog',
    lazy    => 1,
    default => sub {
      my $self = shift;
      $self->model('Chara::BattleLog')->new;
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

  has 'distance' => (
    is      => 'ro',
    isa     => 'Int',
    lazy    => 1,
    default => sub {
      my $self = shift;
      $self->chara->soldier->distance_from_point($self->target->soldier);
    },
  );

  has 'chara_power' => (
    is      => 'ro',
    isa     => 'Jikkoku::Service::BattleCommand::Battle::CharaPower::CharaPower',
    lazy    => 1,
    default => sub {
      my $self = shift;
      $self->service('BattleCommand::Battle::CharaPower::CharaPower')->new({
        chara  => $self->chara,
        target => $self->target,
      });
    },
  );

  has 'target_power' => (
    is      => 'ro',
    isa     => 'Jikkoku::Service::BattleCommand::Battle::CharaPower::CharaPower',
    lazy    => 1,
    default => sub {
      my $self = shift;
      $self->service('BattleCommand::Battle::CharaPower::CharaPower')->new({
        chara  => $self->target,
        target => $self->chara,
      });
    },
  );

  has 'chara_increase_weapon_attr_power' => (
    is      => 'ro',
    isa     => 'Jikkoku::Service::BattleCommand::Battle::IncreaseWeaponAttrPower',
    lazy    => 1,
    default => sub {
      my $self = shift;
      $self->service('BattleCommand::Battle::IncreaseWeaponAttrPower')->new({
        is_win               => ($self->battle_result == $self->WIN ? 1 : 0),
        weapon_attr_affinity => $self->chara_power->weapon_attr_affinity,
      });
    },
  );

  has 'target_increase_weapon_attr_power' => (
    is      => 'ro',
    isa     => 'Jikkoku::Service::BattleCommand::Battle::IncreaseWeaponAttrPower',
    lazy    => 1,
    default => sub {
      my $self = shift;
      $self->service('BattleCommand::Battle::IncreaseWeaponAttrPower')->new({
        is_win               => ($self->battle_result == $self->LOSE ? 1 : 0),
        weapon_attr_affinity => $self->target_power->weapon_attr_affinity,
      });
    },
  );

  has 'is_target_can_counter_attack' => ( is => 'rw', isa => 'Bool', default => 0 );

  has 'turn' => ( is => 'rw', isa => 'Int', default => 1 );

  has 'battle_result' => ( is => 'rw', isa => 'Int', default => NONE );

  with qw( Jikkoku::Service::BattleCommand::BattleCommand );

  sub throw { Jikkoku::Service::Role::BattleActionException->throw(@_) }

  sub get_target_overrider_result {
    my $self = shift;
    my $model = $self->model('ExtensiveState')->new(chara => $self->chara);
    my $result = $model->get_all_with_result->override_battle_target($self->time);
    Option->new($result);
  }

  sub _build_target {
    my $self = shift;
    $self->charactors->get_with_option( $self->target_id )->match(
      # 掩護で身代わりを入れる処理
      Some => sub {
        my $enemy = shift;
        my $orig = $self->get_target_overrider_result->match(
          Some => sub {
            my $result = shift;
# after_override_battle_target_service_class role作成
# test
            $result->after_override_battle_target_service_class_name->new({
              chara          => $self->chara->chara,
              original_enemy => $enemy,
              result         => $result,
              map_log_model  => $self->map_log_model,
            });
            $result->giver;
          },
          None => sub { $enemy },
        );
        $self->class('Chara::ExtChara')->new({
          chara         => $orig,
          town_model    => $self->town_model,
          country_model => $self->country_model,
        });
      },
      None => sub { throw("その武将は存在していないようです。") },
    );
  }

  sub ensure_target_can_battle {
    my $self = shift;
    if ( $self->target->soldier->num <= 0 ) {
      throw("兵士0人では戦闘できません。");
    }
    if ( !$self->target->soldier->is_sortie ) {
      throw("指定した相手武将は出撃していません。");
    }
    if ( $self->target->soldier->battle_map_id ne $self->chara->soldier->battle_map_id ) {
      throw("相手と同じマップ上にいません。");
    }
    if ( $self->target->country_id eq $self->chara->country_id ) {
      throw("同士打ちはできません。");
    }
  }

  sub ensure_can_invasion {
    my $self = shift;

    my $can_attack = $self->diplomacy_model->can_attack(
      $self->chara->country_id,
      $self->target->country_id,
      $self->now_game_date
    );
    if ( $self->target->is_invasion || $self->chara->country->is_neutral || $self->target->country->is_neutral ) {
      $can_attack = 1;
    }
    unless ( $can_attack ) {
      throw('宣戦布告をしていないか、まだ開戦時刻になっていません。'
          . '(他国と戦争するには、自国の幹部が司令部から宣戦布告を行う必要があります。)');
    }

    unless ( $self->target->country->can_invasion ) {
      throw($self->target->country->name
          . 'にはまだ侵攻できません。(戦闘解除まで後 '
          . $self->target->country->remaining_month_until_can_invasion
          . ' ターン)');
    }

    unless ( $self->chara->country->can_invasion ) {
      throw($self->chara->country->name
          . 'の武将はまだ他国に侵攻できません。(戦闘解除まで後 '
          . $self->target->country->name
          . ' ターン)' );
    }

  }

  sub ensure_can_exec {
    my $self = shift;

    $self->ensure_target_can_battle();

    if ( $self->chara->soldier->range < $self->distance ) {
      throw("攻撃が相手に届きません。");
    }

    $self->ensure_can_invasion();

  }

  sub prepare_exec {
    my $self = shift;

    $self->chara->is_attack(1);

    if ( $self->target->soldier->range < $self->distance ) {
      $self->is_target_can_counter_attack(1);
      my $log = sub {
        my $color = shift;
        qq{<span class="$color">【反撃不可】</span>@{[ $self->chara->name ]}の部隊が}
        . qq{射程圏内に入っていないので@{[ $self->target->name ]}は反撃できない！};
      };
      $self->chara->battle_logger->add( $log->('red') );
      $self->target->battle_logger->add( $log->('blue') );
    }

    if ( $self->distance <= CONFUSED_BATTLE_RANGE ) {
      $self->turn( $self->turn + 1 );
      my $log = qq{<span class="red">【乱戦】</span>@{[ $self->chara->name ]}の部隊と}
                . qq{@{[ $self->target->name ]}の部隊の距離が近かったため乱戦となりました。}
                . qq{ターン数+1};
      $self->chara->battle_logger->add($log);
      $self->target->battle_logger->add($log);
    }

  }

  sub exec {
    my $self = shift;

    my @file_handlers = qw( chara target chara_battle_logger target_battle_logger );
    $self->$_->lock for @file_handlers;

    eval {

      $self->prepare_exec();

      my $chara->soldier = $self->chara->soldier;
      $chara->soldier->move_point(0);
      $chara->soldier->occur_move_point_charge_time( $CONFIG->{game}{action_interval_time} );
      $chara->soldier->occur_action_time( $CONFIG->{game}{action_interval_time} );

    };

    if (my $e = $@) {
      $self->$_->abort for @file_handlers;
    }
    else {
      $self->$_->commit for @file_handlers;
    }

  }

  __PACKAGE__->meta->make_immutable;

}

1;

