package Jikkoku::Class::BattleMap::Node::MoveCostAdjuster {

  use Mouse::Role;
  use Jikkoku;

  # method
  requires qw( adjust_move_cost );

}

1;

=head1 NAME
  
  Jikkoku::Class::BattleMap::Node::MoveCostAdjuster

=head1 DESCRIPTION
  
  Jikkoku::Class::BattleMap::Node の cost メソッド実行時に移動コストを調整するためのメソッドを定義するためのロール
  adjust_move_cost
    引数 $self, $origin_cost 

=cut
