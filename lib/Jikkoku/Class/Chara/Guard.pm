package Jikkoku::Class::Chara::Guard {

  use Mouse;
  use Jikkoku;

  has 'chara' => (
    is       => 'ro',
    isa      => 'Jikkoku::Class::Chara',
    handles  => +{ map { $_ => 'weapon_' . $_ } qw/ name power / },
    weak_ref => 1,
    required => 1,
  );

  __PACKAGE__->meta->make_immutable;

}

1;

