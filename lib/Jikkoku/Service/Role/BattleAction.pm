package Jikkoku::Service::Role::BattleAction {

  use Mouse::Role;
  use Jikkoku;

  use Jikkoku::Util;
  use Jikkoku::Model::Config;
  use Jikkoku::Service::Role::BattleActionException;

  has 'chara_soldier' => (
    is      => 'ro',
    isa     => 'Jikkoku::Class::Chara::Soldier',
    lazy    => 1,
    default => sub {
      my $self = shift;
      $self->chara->soldier;
    },
  );

  has 'time' => (
    is      => 'ro',
    isa     => 'Num',
    lazy    => 1,
    default => sub { time },
  );

  with 'Jikkoku::Role::Loader';

  # method
  requires qw( ensure_can_exec exec );

  before ensure_can_exec => sub {
    my $self = shift;
    unless ( Jikkoku::Util::is_game_update_hour ) {
      Jikkoku::Service::Role::BattleActionException
        ->throw("BM上で行動可能な時間帯ではありません。");
    }
    unless ( $self->chara_soldier->is_sortie) {
      Jikkoku::Service::Role::BattleActionException->throw("出撃していません。");
    }
    if ( $self->chara_soldier->num < 0 ) {
      $self->chara_soldier->retreat;
      $self->chara->save;
      Jikkoku::Service::Role::BattleActionException->throw("兵士がいません。");
    }
  };

  around exec => sub {
    my ($origin, $self, $args) = @_;
    $self->ensure_can_exec($args);
    $self->$origin($args);
  };

  sub calc_success_ratio { 1 }

  # その行動が成功するかどうかを判定, action method 内で使用(移動, 関所出入りは除く)
  sub determine_whether_succeed {
    my $self = shift;
    my $origin_success_ratio = $self->calc_success_ratio(@_);
    my $success_ratio = $origin_success_ratio;
    $success_ratio += $self->chara->states->adjust_battle_action_success_ratio($origin_success_ratio);
    $success_ratio > rand(1);
  }

}

1;

