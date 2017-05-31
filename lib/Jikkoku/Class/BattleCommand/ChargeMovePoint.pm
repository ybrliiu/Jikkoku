package Jikkoku::Class::BattleCommand::ChargeMovePoint {

  use Mouse;
  use Jikkoku;

  has 'name' => ( is => 'ro', isa => 'Str', default => '移動ポイント補充' );

  with 'Jikkoku::Class::BattleCommand::BattleCommand';

  __PACKAGE__->meta->make_immutable;

}

1;
