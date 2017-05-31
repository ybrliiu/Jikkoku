package Jikkoku::Class::BattleCommand::WeaponShop {

  use Mouse;
  use Jikkoku;

  has 'name' => ( is => 'ro', isa => 'Str', default => '武器屋' );

  with 'Jikkoku::Class::BattleCommand::BattleCommand';

  __PACKAGE__->meta->make_immutable;

}

1;

