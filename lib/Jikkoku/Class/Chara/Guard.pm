package Jikkoku::Class::Chara::Guard {

  use Mouse;
  use Jikkoku;

  has 'chara' => (
    is       => 'ro',
    isa      => 'Jikkoku::Class::Chara',
    handles  => +{ map { $_ => 'guard_' . $_ } qw/ name power / },
    weak_ref => 1,
    required => 1,
  );

  sub skill {
    my $self = shift;
    if (@_) {
      $self->chara->_equipment_skill->set(gurad => shift);
    } else {
      $self->chara->_equipment_skill->get('guard');
    }
  }

  __PACKAGE__->meta->make_immutable;

}

1;

