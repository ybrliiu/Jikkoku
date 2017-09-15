package Jikkoku::Class::Chara::Weapon {

  use Mouse;
  use Jikkoku;

  has 'chara' => (
    is       => 'ro',
    isa      => 'Jikkoku::Class::Chara',
    handles  => +{ map { $_ => 'weapon_' . $_ } qw/ name power attr_power skill_id / },
    weak_ref => 1,
    required => 1,
  );

  has 'attr' => (
    is      => 'ro',
    does    => 'Jikkoku::Class::Weapon::Attr::Attr',
    lazy    => 1,
    default => sub {
      my $self = shift;
      $self->model('Weapon::Attr')->new->get( $self->chara->weapon_attr );
    },
  );

  with qw( Jikkoku::Role::Loader );

  __PACKAGE__->meta->make_immutable;

}

1;

