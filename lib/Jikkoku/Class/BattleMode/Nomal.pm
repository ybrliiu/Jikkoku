package Jikkoku::Class::BattleMode::Nomal {

  use Mouse;
  use Jikkoku;

  has 'name'           => ( is => 'ro', isa => 'Str', default => '通常' );
  has 'consume_morale' => ( is => 'ro', isa => 'Int', default => 0 );

  with qw( Jikkoku::Class::BattleMode::BattleMode );

  __PACKAGE__->meta->make_immutable;

}

1;

