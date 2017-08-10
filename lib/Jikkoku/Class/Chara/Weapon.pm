package Jikkoku::Class::Chara::Weapon {

  use Mouse;
  use Jikkoku;

  has 'chara' => (
    is       => 'ro',
    isa      => 'Jikkoku::Class::Chara',
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

  sub _add_alias_method {
    my $class = shift;
    for my $method_name (qw/ name power attr_power /) {
      my $to = "weapon_$method_name";
      $class->meta->add_method($method_name => sub {
        my $self = shift;
        if (@_) {
          my $value = shift;
          $self->chara->$to($value);
        }
        $self->chara->$to;
      });
    }
  }

  __PACKAGE__->_add_alias_method;
  __PACKAGE__->meta->make_immutable;

}

1;

