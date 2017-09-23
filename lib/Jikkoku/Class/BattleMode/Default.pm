package Jikkoku::Class::BattleMode::Default {

  use Mouse;
  use Jikkoku;

  has 'name'           => ( is => 'ro', isa => 'Str', default => '通常' );
  has 'consume_morale' => ( is => 'ro', isa => 'Int', default => 0 );

  with qw( Jikkoku::Class::BattleMode::BattleMode );

  sub can_use { 1 }

  __PACKAGE__->meta->make_immutable;

}

1;

