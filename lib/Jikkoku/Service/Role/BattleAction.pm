package Jikkoku::Service::Role::BattleAction {

  use Mouse::Role;
  use Jikkoku;

  use Jikkoku::Util;
  use Jikkoku::Model::Config;
  use Jikkoku::Service::Role::BattleActionException;

  sub chara;
  has 'chara' => ( is => 'ro', isa => 'Jikkoku::Class::Chara::ExtChara', required => 1 );

  has 'time' => (
    is      => 'ro',
    isa     => 'Num',
    lazy    => 1,
    default => sub { time },
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

  has 'battle_map_model' => (
    is      => 'ro',
    isa     => 'Jikkoku::Model::BattleMap',
    lazy    => 1,
    default => sub {
      my $self = shift;
      $self->model('BattleMap')->new;
    },
  );

  with 'Jikkoku::Role::Loader';

  # method
  requires qw( ensure_can_exec exec calc_success_ratio );

  before ensure_can_exec => sub {
    my $self = shift;
    unless ( Jikkoku::Util::is_game_update_hour ) {
      Jikkoku::Service::Role::BattleActionException
        ->throw("BM上で行動可能な時間帯ではありません。");
    }
    unless ( $self->chara->soldier->is_sortie) {
      Jikkoku::Service::Role::BattleActionException->throw("出撃していません。");
    }
    if ( $self->chara->soldier->num < 0 ) {
      $self->chara->soldier->retreat;
      $self->chara->save;
      Jikkoku::Service::Role::BattleActionException->throw("兵士がいません。");
    }
  };

  around exec => sub {
    my ($origin, $self, $args) = @_;
    $self->ensure_can_exec($args);
    $self->$origin($args);
  };

  around calc_success_ratio => sub {
    my ($orig, $self) = (shift, shift);
    my $orig_ratio = $self->$orig(@_);
    my $ratio = $orig_ratio;
    $ratio += $self->service('States::AdjustBattleActionSuccessRatio::AdjustSuccessRatio')->new({
      chara                => $self->chara,
      origin_success_ratio => $orig_ratio,
    })->adjust_success_ratio;
    $ratio;
  };

  # その行動が成功するかどうかを判定, action method 内で使用(移動, 関所出入りは除く)
  sub determine_whether_succeed {
    my $self = shift;
    $self->calc_success_ratio(@_) > rand(1);
  }

}

1;

