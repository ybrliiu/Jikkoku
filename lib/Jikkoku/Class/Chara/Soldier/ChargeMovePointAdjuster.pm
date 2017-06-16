package Jikkoku::Class::Chara::Soldier::ChargeMovePointAdjuster {

  use Mouse::Role;
  use Jikkoku;

  # methods
  requires qw( adjust_soldier_charge_move_point_time );

}

1;

# 移動ポイント補充にかかる時間を調整
# adjust_soldier_charge_move_point_time($self, $orig_time)

