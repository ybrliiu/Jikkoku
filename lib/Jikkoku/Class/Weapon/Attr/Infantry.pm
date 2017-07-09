package Jikkoku::Class::Weapon::Attr::Infantry {

  use Mouse;
  use Jikkoku;

  has 'name' => ( is => 'ro', isa => 'Str', default => '歩' );

  with qw( Jikkoku::Class::Weapon::Attr::Attr );

  sub _build_advantageous_attrs {
    [qw/ 弓 弓騎 /];
  }

  __PACKAGE__->meta->make_immutable;

}

1;

