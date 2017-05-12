package Jikkoku::Class::Role::BattleAction::BattleActionSuccessRatioAdjuster {

  use Mouse::Role;
  use Jikkoku;

  # methods
  requires qw( adjust_battle_action_success_ratio );

}

1;

=head1 NAME
  
  Jikkoku::Class::Role::BattleAction::BattleActioSuccessRatioAdjuster

=head1 DESCRIPTION
  
  Jikkoku::Class::Role::BattleAction::action 実行時の成功率を調整するメソッドを提供するロール
  adjust_battle_action_success_ratio
    引数 $self, $origin_success_ratio

=cut