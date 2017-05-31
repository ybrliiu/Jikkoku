package Jikkoku::Class::BattleCommand::Exit {

  use Mouse;
  use Jikkoku;

  has 'name' => ( is => 'ro', isa => 'Str', default => '出城' );

  with 'Jikkoku::Class::BattleCommand::BattleCommand';

  __PACKAGE__->meta->make_immutable;

}

1;
