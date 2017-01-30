package Jikkoku::Class::Role::BattleAction {

  use Mouse::Role;
  use Jikkoku;

  use Jikkoku::Util qw( validate_values is_game_update_hour );
  use Jikkoku::Model::Config;

  sub throw {
    my $mes = shift;
    Jikkoku::Class::Role::BattleActionException->throw($mes);
  }

  has 'chara' => (is => 'ro', weak_ref => 1, required => 1);

  requires qw( ensure_can_action action );

  before ensure_can_action => sub {
    my ($self) = @_;
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
    $self->chara->commit;
    # ensure_can_action で最後に返された値が引数として渡される
    $self->$origin( @ret );
  };

}

package Jikkoku::Class::Role::BattleActionException {

  use Jikkoku;
  use parent 'Jikkoku::Exception';

}

1;
