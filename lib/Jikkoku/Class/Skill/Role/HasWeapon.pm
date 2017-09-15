package Jikkoku::Class::Skill::Role::HasWeapon {

  use Mouse::Role;
  use Jikkoku;
  
  requires qw( ACQUIRE_SIGN );

  sub is_acquired {
    my $self = shift;
    $self->chara->weapon->skill == $self->ACQUIRE_SIGN;
  }

  sub acquire {
    my $self = shift;
    $self->chara->weapon->skill($self->ACQUIRE_SIGN);
  }

}

1;

