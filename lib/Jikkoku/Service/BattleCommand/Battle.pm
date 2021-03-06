package Jikkoku::Service::BattleCommand::Battle {

  use Mouse;
  use Jikkoku;
  use Option;

  use List::Util qw( sum );
  use Jikkoku::Util qw( decamelize );
  use Jikkoku::Model::Config;

  use Jikkoku::Service::BattleCommand::Battle::Result;
  use Jikkoku::Service::BattleCommand::Battle::AdjustTurnCalculator;
  use Jikkoku::Service::BattleCommand::Battle::BattleLoop;
  use Jikkoku::Service::BattleCommand::Battle::Chara;
  use Jikkoku::Service::BattleCommand::Battle::CharaPower::CharaPower;
  use Jikkoku::Service::BattleCommand::Battle::IncreaseWeaponAttrPower;

  # alias
  use constant {
    Result                => 'Jikkoku::Service::BattleCommand::Battle::Result',
    AdjustTurnCalculator  => 'Jikkoku::Service::BattleCommand::Battle::AdjustTurnCalculator',
    BattleActionException => 'Jikkoku::Service::Role::BattleActionException',
  };

  use constant {
    DEFAULT_TURN => 1,

    # 乱戦になる範囲
    CONFUSED_BATTLE_RANGE => 1,
  };

  my $CONFIG = Jikkoku::Model::Config->get;

  has 'traget_id'         => ( is => 'ro', isa => 'Str', required => 1 );
  has 'battle_mode_id'    => ( is => 'ro', isa => 'Str', default  => 'Default' );
  has 'turn'              => ( is => 'ro', isa => 'Int', lazy => 1, builder => '_build_turn' );
  has 'battle_result'     => ( is => 'rw', isa => 'Int',  default => Result->NONE );
  has 'occur_action_time' => ( is => 'ro', isa => 'Int', lazy => 1, builder => '_build_occur_action_time' );

  has '_chara' => (
    is       => 'ro',
    isa      => 'Jikkoku::Class::Chara::ExtChara',
    init_arg => 'chara',
    required => 1,
  );

  for my $name (qw/ chara target /) {
    has $name => (
      is      => 'ro',
      isa     => 'Jikkoku::Service::BattleCommand::Battle::Chara',
      lazy    => 1,
      builder => "_build_${name}",
    );
  }

  has 'charactors' => (
    is      => 'ro',
    isa     => 'Jikkoku::Model::Chara::Result',
    lazy    => 1,
    default => sub {
      my $self = shift;
      $self->chara_model->get_all_with_result;
    },
  );

  for my $class_name (qw/ Chara Town Country Diplomacy MapLog /) {
    my $attr_name = decamelize $class_name;
    has "${attr_name}_model" => (
      is      => 'ro',
      isa     => "Jikkoku::Model::${class_name}",
      lazy    => 1,
      default => sub { $_[0]->model($class_name)->new },
    );
  }

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
      Jikkoku::Service::BattleCommand::Battle::CharaPower::CharaPower->new({
        chara    => $self->chara,
        target   => $self->target,
        is_siege => $self->is_siege,
      });
    },
  );

  has 'target_power' => (
    is      => 'ro',
    isa     => 'Jikkoku::Service::BattleCommand::Battle::CharaPower::CharaPower',
    lazy    => 1,
    default => sub {
      my $self = shift;
      Jikkoku::Service::BattleCommand::Battle::CharaPower::CharaPower->new({
        chara    => $self->target,
        target   => $self->chara,
        is_siege => 0,
      });
    },
  );

  has 'chara_increase_weapon_attr_power' => (
    is      => 'ro',
    isa     => 'Jikkoku::Service::BattleCommand::Battle::IncreaseWeaponAttrPower',
    lazy    => 1,
    default => sub {
      my $self = shift;
      Jikkoku::Service::BattleCommand::Battle::IncreaseWeaponAttrPower->new({
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
      Jikkoku::Service::BattleCommand::Battle::IncreaseWeaponAttrPower->new({
        is_win               => ($self->battle_result == $self->LOSE ? 1 : 0),
        weapon_attr_affinity => $self->target_power->weapon_attr_affinity,
      });
    },
  );

  with qw( Jikkoku::Service::BattleCommand::BattleCommand );

  sub is_siege() { 0 }

  sub _build_chara {
    my $self = shift;
    Jikkoku::Service::BattleCommand::Battle::Chara->new({
      %{ $self->_chara },
      is_attack      => 1,
      battle_mode_id => $self->battle_mode_id,
    });
  }

  sub _build_occur_action_time {
    my $self = shift;
    my $chara = $self->chara;
    my $orig_time = $CONFIG->{game}{action_interval_time};
    if ( $chara->battle_mode->DOES('Jikkoku::Service::BattleCommand::Battle::OccurActionTimeOverwriter') ) {
      $orig_time = $chara->battle_mode->overwrite_battle_occur_action_time($orig_time);
      my $log = sub {
        my $color = shift;
        qq{<span class="$color">【@{[ $chara->battle_mode->name ]}】@{[ $chara->name ]}の行動待機時間が${orig_time}秒になりました！};
      };
      $chara->battle_logger->add( $log->('red') );
      $self->target->battle_logger->add( $log->('blue') );
    }
    $orig_time;
  }

  sub get_target_overrider_result {
    my ($self, $enemy) = @_;
    my $result = $self->chara->extensive_states->get_all_with_result->override_battle_target($enemy, $self->time);
    option $result;
  }

  sub _build_target {
    my $self = shift;
    $self->charactors->get_with_option( $self->target_id )->match(
      # 掩護で身代わりを入れる処理
      Some => sub {
        my $_enemy = shift;
        my $enemy = Jikkoku::Service::BattleCommand::Battle::Chara->new(
          chara         => $_enemy,
          town_model    => $self->town_model,
          country_model => $self->country_model,
        );
        my $orig = $self->get_target_overrider_result($enemy)->match(
          Some => sub {
            my $result = shift;
            $result->after_override_battle_target_service_class_name->new({
              chara          => $self->chara,
              original_enemy => $enemy,
              result         => $result,
              map_log_model  => $self->map_log_model,
            })->notice();
            $result->giver;
          },
          None => sub { $enemy },
        );
      },
      None => sub { BattleActionException->throw("その武将は存在していないようです。") },
    );
  }

  sub _build_turn {
    my $self = shift;
    my $turn = DEFAULT_TURN;
    $turn += 1 if $self->_is_confused_battle;
    my $chara_calculator  = AdjustTurnCalculator->new(chara => $self->chara);
    my $target_calculator = AdjustTurnCalculator->new(chara => $self->target);
    $turn += $chara_calculator->calc() + $target_calculator->calc();
    $turn;
  }

  sub _is_confused_battle {
    my $self = shift;
    if ( $self->distance <= CONFUSED_BATTLE_RANGE ) {
      my $log = qq{<span class="red">【乱戦】</span>@{[ $self->chara->name ]}の部隊と}
                . qq{@{[ $self->target->name ]}の部隊の距離が近かったため乱戦となりました。}
                . qq{ターン数+1};
      $self->chara->battle_logger->add($log);
      $self->target->battle_logger->add($log);
      1;
    } else {
      0;
    }
  }

  sub set_target_can_take_damage {
    my $self = shift;
    if ( $self->target->soldier->range < $self->distance ) {
      my $log = sub {
        my $color = shift;
        qq{<span class="$color">【反撃不可】</span>@{[ $self->chara->name ]}の部隊が}
        . qq{射程圏内に入っていないので@{[ $self->target->name ]}は反撃できない！};
      };
      $self->chara->battle_logger->add( $log->('red') );
      $self->target->battle_logger->add( $log->('blue') );
      $self->target->can_take_damage(0);
    }
  }

  sub ensure_target_can_battle {
    my $self = shift;
    if ( $self->target->soldier->num <= 0 ) {
      BattleActionException->throw("兵士0人では戦闘できません。");
    }
    if ( !$self->target->soldier->is_sortie ) {
      BattleActionException->throw("指定した相手武将は出撃していません。");
    }
    if ( $self->target->soldier->battle_map_id ne $self->chara->soldier->battle_map_id ) {
      BattleActionException->throw("相手と同じマップ上にいません。");
    }
    if ( $self->target->country_id eq $self->chara->country_id ) {
      BattleActionException->throw("同士打ちはできません。");
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
      BattleActionException->throw('宣戦布告をしていないか、まだ開戦時刻になっていません。'
          . '(他国と戦争するには、自国の幹部が司令部から宣戦布告を行う必要があります。)');
    }

    unless ( $self->target->country->can_invasion ) {
      BattleActionException->throw($self->target->country->name
          . 'にはまだ侵攻できません。(戦闘解除まで後 '
          . $self->target->country->remaining_month_until_can_invasion
          . ' ターン)');
    }

    unless ( $self->chara->country->can_invasion ) {
      BattleActionException->throw($self->chara->country->name
          . 'の武将はまだ他国に侵攻できません。(戦闘解除まで後 '
          . $self->target->country->name
          . ' ターン)' );
    }

  }

  sub ensure_can_exec {
    my $self = shift;
    $self->ensure_target_can_battle();
    if ( $self->chara->soldier->range < $self->distance ) {
      BattleActionException->throw("攻撃が相手に届きません。");
    }
    $self->ensure_can_invasion();
  }

  sub prepare_exec {
    my $self = shift;
    $self->chara->battle_mode->use();
    # occur_action_time write_to_log
    $self->set_target_can_take_damage();
    $self->chara_power->write_to_log();
    $self->target_power->write_to_log();
  }

  sub exec {
    my $self = shift;

    my @file_handlers = qw( chara target chara_battle_logger target_battle_logger );
    $self->$_->lock for @file_handlers;

    eval {
      $self->prepare_exec();
      my $soldier = $self->chara->soldier;
      $soldier->move_point(0);
      $soldier->occur_move_point_charge_time( $CONFIG->{game}{action_interval_time} );
      $soldier->occur_action_time( $self->occur_action_time );
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

