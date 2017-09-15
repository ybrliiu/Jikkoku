package Jikkoku::Class::Skill::Role::HasBook {

  use Mouse::Role;
  use Jikkoku;
  
  requires qw( ACQUIRE_SIGN BOOK_NAME );

  sub is_acquired {
    my $self = shift;
    $self->chara->book->skill_id == $self->ACQUIRE_SIGN;
  }

  sub acquire {
    my $self = shift;
    $self->chara->book->skill_id($self->ACQUIRE_SIGN);
  }

  around description_of_acquire_body => sub {
    my ($orig, $self) = @_;
    '書物 : ' . $self->BOOK_NAME . 'を装備していること。';
  };

}

1;

