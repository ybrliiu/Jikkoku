package Jikkoku::Class::Weapon::Attr::Cavalry {

  use Mouse;
  use Jikkoku;

  has 'name' => ( is => 'ro', isa => 'Str', default => '騎' );

  with qw( Jikkoku::Class::Weapon::Attr::Attr );

  sub _build_advantageous_attrs {
    [qw/ 歩 /];
  }

  __PACKAGE__->meta->make_immutable;

}

1;

