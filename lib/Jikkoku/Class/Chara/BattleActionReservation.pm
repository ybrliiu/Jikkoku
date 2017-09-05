package Jikkoku::Class::Chara::BattleActionReservation {

  use Mouse;
  use Jikkoku;

  use constant {
    # 移動する方角
    MOVE_NONE  => 0,
    MOVE_LEFT  => 1,
    MOVE_RIGHT => 2,
    MOVE_DOWN  => 3,
    MOVE_UP    => 4,

    # コマンド失敗時のオプション
    FAIL_COMMAND_ERASE     => 0,
    FAIL_COMMAND_NOT_ERASE => 1,

    # 敵遭遇時のオプション
    BATTLE_WITH_ENEMY_ENCOUNTER      => 0,
    DONT_BATTLE_WITH_ENEMY_ENCOUNTER => 1,
  };

  with 'Jikkoku::Class::Role::TextData';

  has 'id'                   => ( metaclass => 'Column', is => 'ro', isa => 'Int', default => 0 );
  has 'move_direction'       => ( metaclass => 'Column', is => 'ro', isa => 'Int', default => MOVE_NONE );
  has 'description'          => ( metaclass => 'Column', is => 'ro', isa => 'Str', default => ' - ' );
  has 'not_used'             => ( metaclass => 'Column', is => 'ro', isa => 'Str', default => '' );
  has 'auto_move_route'      => ( metaclass => 'Column', is => 'ro', isa => 'Str', default => '' );
  has 'fail_command_option'  => ( metaclass => 'Column', is => 'ro', isa => 'Int', default => FAIL_COMMAND_NOT_ERASE );
  has 'encount_enemy_option' => ( metaclass => 'Column', is => 'ro', isa => 'Int', default => BATTLE_WITH_ENEMY_ENCOUNTER );

  __PACKAGE__->meta->make_immutable;

}

1;

