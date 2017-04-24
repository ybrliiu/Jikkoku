package Jikkoku::Class::Role::BattleAction {

  use Mouse::Role;
  use Jikkoku;

  use Jikkoku::Util qw( validate_values is_game_update_hour );
  use Jikkoku::Model::Config;

  sub throw {
    my $mes = shift;
    Jikkoku::Class::Role::BattleActionException->throw($mes);
  }

  has 'chara' => ( is => 'ro', isa => 'Jikkoku::Class::Chara', weak_ref => 1, required => 1 );

  requires qw( ensure_can_action action );

  before ensure_can_action => sub {
    my $self = shift;
    throw("BM上で行動可能な時間帯ではありません。") unless is_game_update_hour;
    throw("出撃していません。") unless $self->chara->is_sortie;
    if ( $self->chara->soldier_num < 0 ) {
      $self->chara->soldier_retreat;
      $self->chara->save;
      throw("兵士がいません。");
    }
  };

  around action => sub {
    my ($origin, $self, $args) = @_;
    my @ret = $self->ensure_can_action($args);
    # ensure_can_action で最後に返された値が引数として渡される
    $self->$origin( @ret );
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

package Jikkoku::Class::Role::BattleActionException {

  use Jikkoku;
  use parent 'Jikkoku::Exception';

}

1;
