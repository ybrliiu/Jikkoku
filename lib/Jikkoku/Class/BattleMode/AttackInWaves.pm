package Jikkoku::Class::BattleMode::AttackInWaves {

  use Mouse;
  use Jikkoku;

  has 'name'           => ( is => 'ro', isa => 'Str', default => '波状攻撃' );
  has 'consume_morale' => ( is => 'ro', isa => 'Int', default => 7 );

  with qw( Jikkoku::Class::BattleMode::BattleMode );

  __PACKAGE__->meta->make_immutable;

}

1;

