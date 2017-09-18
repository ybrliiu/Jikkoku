package Jikkoku::Class::BattleMode::Siege {

  use Mouse;
  use Jikkoku;

  has 'name'           => ( is => 'ro', isa => 'Str', default => '包囲' );
  has 'consume_morale' => ( is => 'ro', isa => 'Int', default => 20 );

  with qw( Jikkoku::Class::BattleMode::BattleMode );

  __PACKAGE__->meta->make_immutable;

}

1;

