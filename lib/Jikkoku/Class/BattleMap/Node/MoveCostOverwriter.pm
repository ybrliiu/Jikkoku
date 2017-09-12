package Jikkoku::Class::BattleMap::Node::MoveCostOverwriter {

  use Mouse::Role;
  use Jikkoku;

  # method
  requires qw( overwrite_move_cost );

}

1;

=head1 NAME
  
  Jikkoku::Class::BattleMap::Node::MoveCostOverwriter

=head1 DESCRIPTION
  
  Jikkoku::Class::BattleMap::Node の cost メソッド実行時の移動コスト計算にフック可能なメソッドを提供するロール

  overwrite_move_cost
    引数 $self, $origin_cost 

  返却値の値が移動コストを上書きする
  複数のoverwrite_move_costを実行する状態(state class)がある場合、新しい物を優先する
  なお、overwrite_move_costの後でadjust_move_costが適用されます

=cut
