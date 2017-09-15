package Jikkoku::Class::Skill::HasWeapon::RiceBag {

  use Mouse;
  use Jikkoku;

  use constant ACQUIRE_SIGN => 1;

  has 'name' => ( is => 'ro', isa => 'Str', default => '米俵' );

  with qw(
    Jikkoku::Class::Skill::Skill
    Jikkoku::Class::Skill::Role::HasWeapon
  );

  sub description {}

  __PACKAGE__->meta->make_immutable;

}

1;

