package Jikkoku::Class::BattleCommand::Battle {

  use Mouse;
  use Jikkoku;

  has 'name' => ( is => 'ro', isa => 'Str', default => '戦闘' );

  with 'Jikkoku::Class::BattleCommand::BattleCommand';

  __PACKAGE__->meta->make_immutable;

}

1;

