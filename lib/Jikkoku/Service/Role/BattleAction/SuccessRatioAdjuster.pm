package Jikkoku::Service::Role::BattleAction::SuccessRatioAdjuster {

  use Mouse::Role;
  use Jikkoku;

  # methods
  requires qw( adjust_battle_action_success_ratio );

}

1;

=head1 NAME
  
  Jikkoku::Service::Role::BattleAction::SuccessRatioAdjuster

=head1 DESCRIPTION
  
  Jikkoku::Service::Role::BattleAction の成功率を調整するメソッドを提供するロール
  adjust_battle_action_success_ratio
    引数 $self, $origin_success_ratio

=cut
