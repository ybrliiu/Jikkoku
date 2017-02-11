package Jikkoku::Model::Chara::BattleActionReservation {

  use Jikkoku;
  use parent 'Jikkoku::Model::Base::TextData::Command';

  use constant {
    MAX           => 300,
    COLUMNS       => [qw/
      id move_direction description not_used auto_move_route
      fail_command_option encount_enemy_option
    /],
    EMPTY_DATA    => {
      id          => 0,
      description => '何もしない',
    },
    FILE_DIR_PATH => 'charalog/auto_com/',
  };

}

1;
