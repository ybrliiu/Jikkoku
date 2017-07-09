package Jikkoku::Class::Weapon::Attr::Bowman {

  use Mouse;
  use Jikkoku;

  has 'name' => ( is => 'ro', isa => 'Str', default => '弓' );

  with qw( Jikkoku::Class::Weapon::Attr::Attr );

  sub _build_advantageous_attrs {
    [qw/ 騎 弓騎 /];
  }

  __PACKAGE__->meta->make_immutable;

}

1;

