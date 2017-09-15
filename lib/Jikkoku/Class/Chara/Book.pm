package Jikkoku::Class::Chara::Book {

  use Mouse;
  use Jikkoku;

  has 'chara' => (
    is       => 'ro',
    isa      => 'Jikkoku::Class::Chara',
    handles  => +{ map { $_ => 'book_' . $_ } qw/ name power / },
    weak_ref => 1,
    required => 1,
  );

  sub skill_id {
    my $self = shift;
    if (@_) {
      $self->chara->_equipment_skill_id->set(book => shift);
    } else {
      $self->chara->_equipment_skill_id->get('book');
    }
  }

  __PACKAGE__->meta->make_immutable;

}

1;

