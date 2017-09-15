package Jikkoku::Class::Skill::HasWeapon::CoinBunch {

  use Mouse;
  use Jikkoku;

  use constant ACQUIRE_SIGN => 4;

  has 'name' => ( is => 'ro', isa => 'Str', default => '短陌' );

  with qw(
    Jikkoku::Class::Skill::Skill
    Jikkoku::Class::Skill::Role::HasWeapon
  );

  sub description {}

  __PACKAGE__->meta->make_immutable;

}

1;

