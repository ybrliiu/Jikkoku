package Jikkoku::Class::Chara::Soldier::MaxMovePointAdjuster {

  use Mouse::Role;
  use Jikkoku;

  # method
  requires qw( adjust_soldier_max_move_point );

}

1;

=head1 NAME

  Jikkoku::Class::Chara::Soldier::MaxMovePointAdjuster

=head1 DESCRIPTION

  Chara::Soldier の最大移動ポイントを調整するスキル、状態向けのRole

  adjust_soldier_max_move_point($self, $orig_max_move_point)

=cut
