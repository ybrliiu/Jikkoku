package Jikkoku::Class::BattleMode::BattleMode {

  use Mouse::Role;
  use Jikkoku;

  requires qw( name consume_morale );

  has 'chara' => ( is => 'ro', isa => 'Jikkoku::Class::Chara::ExtChara', required => 1 );

}

1;

