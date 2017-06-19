package Jikkoku::Service::BattleCommand::Battle {

  use Mouse;
  use Jikkoku;

  has 'traget_id' => ( is => 'ro', isa => 'Str', required => 1 );

  has 'target' => (
    is      => 'ro',
    isa     => 'Jikkoku::Class::Chara',
    lazy    => 1,
    builder => '_build_target',
  );

  has 'target_soldier' => (
    is      => 'ro',
    isa     => 'Jikkoku::Class::Chara::Soldier',
    lazy    => 1,
    default => sub {
      my $self = shift;
      $self->target->soldier;
    },
  );

  has 'is_target_invasion' => (
    is      => 'ro',
    isa     => 'Bool',
    lazy    => 1,
    default => sub {
      my $self = shift;
      $self->service('Chara::Soldier::JudgeInvasionOrDefence')->new({
        chara         => $self->target,
        chara_soldier => $self->target_soldier,
        town_model    => $self->town_model,
      })->judge();
    },
  );

  has 'target_country' => (
    is      => 'ro',
    isa     => 'Jikkoku::Class::Country',
    lazy    => 1,
    default => sub {
      my $self = shift;
      $self->country_model->get_with_option( $self->target->country_id )->match(
        Some => sub { $_ },
        None => sub { $self->country_model->neutral },
      );
    },
  );

  has 'chara_country' => (
    is      => 'ro',
    isa     => 'Jikkoku::Class::Country',
    lazy    => 1,
    default => sub {
      my $self = shift;
      $self->country_model->get_with_option( $self->chara->country_id )->match(
        Some => sub { $_ },
        None => sub { $self->country_model->neutral },
      );
    },
  );

  has 'is_chara_invasion' => (
    is      => 'ro',
    isa     => 'Bool',
    lazy    => 1,
    default => sub {
      my $self = shift;
      $self->service('Chara::Soldier::JudgeInvasionOrDefence')->new({
        chara         => $self->chara,
        chara_soldier => $self->chara_soldier,
        town_model    => $self->town_model,
      })->judge();
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

  has 'charactors' => (
    is      => 'ro',
    isa     => 'Jikkoku::Model::Chara::Result',
    lazy    => 1,
    default => sub {
      my $self = shift;
      $self->chara_model->get_all_with_result;
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

  has 'town_model' => (
    is      => 'ro',
    isa     => 'Jikkoku::Model::Town',
    lazy    => 1,
    default => sub {
      my $self = shift;
      $self->model('Town')->new;
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

  has 'diplomacy_model' => (
    is      => 'ro',
    isa     => 'Jikkoku::Model::Diplomacy',
    lazy    => 1,
    default => sub {
      my $self = shift;
      $self->model('Diplomacy')->new;
    },
  );

  has 'battle_turn' => ( is => 'rw', isa => 'Int', default => 1 );

  with qw( Jikkoku::Service::Role::BattleAction );

  sub throw { Jikkoku::Service::Role::BattleActionException->throw(@_) }

  sub _build_target {
    my $self = shift;
    $self->charactors->get_with_option( $self->target_id )->match(
      # 掩護で身代わりを入れる処理
      Some => sub { $_ },
      None => sub { throw("その武将は存在していないようです。") },
    );
  }

  sub ensure_target_can_battle {
    my $self = shift;
    if ( $self->target_soldier->num <= 0 ) {
      throw("兵士0人では戦闘できません。");
    }
    if ( !$self->target_soldier->is_sortie ) {
      throw("指定した相手武将は出撃していません。");
    }
    if ( $self->target_soldier->battle_map_id ne $self->chara_soldier->battle_map_id ) {
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
    if ( $self->is_target_invasion || $self->chara_country->is_neutral || $self->target_country->is_neutral ) {
      $can_attack = 1;
    }
    unless ( $can_attack ) {
      throw('宣戦布告をしていないか、まだ開戦時刻になっていません。'
          . '(他国と戦争するには、自国の幹部が司令部から宣戦布告を行う必要があります。)');
    }

    unless ( $self->target_country->can_invasion ) {
      throw($self->target_country->name
          . 'にはまだ侵攻できません。(戦闘解除まで後 '
          . $self->target_country->remaining_month_until_can_invasion
          . ' ターン)');
    }

    unless ( $self->chara_country->can_invasion ) {
      throw($self->chara_country->name
          . 'の武将はまだ他国に侵攻できません。(戦闘解除まで後 '
          . $self->target_country->name
          . ' ターン)' );
    }

  }

  sub ensure_can_exec {
    my $self = shift;

    $self->ensure_target_can_battle();

    if ( $chara_soldier->range < $chara_soldier->distance_from_point($target_soldier) ) {
      throw("攻撃が相手に届きません。");
    }

    $self->ensure_can_invasion();

  }

  sub exec {
    my $self = shift;
  }

  __PACKAGE__->meta->make_immutable;

}

1;

