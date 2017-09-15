package Jikkoku::Class::Skill::HasWeapon::Kibun {

  use Mouse;
  use Jikkoku;

  use constant {
    ACQUIRE_SIGN => 3,
    WEAPON_NAME  => '干将・莫耶',
  };

  has 'name' => ( is => 'ro', isa => 'Str', default => '龜文' );

  with qw(
    Jikkoku::Class::Skill::Skill
    Jikkoku::Class::Skill::Role::HasWeapon
  );

  sub description {}

  __PACKAGE__->meta->make_immutable;

}

1;

