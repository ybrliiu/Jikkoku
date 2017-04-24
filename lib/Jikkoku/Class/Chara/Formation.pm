package Jikkoku::Class::Chara::Formation {

  use Mouse;
  use Jikkoku;
  extends 'Jikkoku::Class::Formation';

  has 'chara' => (
    is       => 'ro',
    isa      => 'Jikkoku::Class::Chara',
    weak_ref => 1,
    required => 1,
  );

  sub is_available {
    my $self = shift;
    $self->chara->class >= $self->class && $self->acquire_condition->($self->chara);
  }

  __PACKAGE__->meta->make_immutable;

}

1;

