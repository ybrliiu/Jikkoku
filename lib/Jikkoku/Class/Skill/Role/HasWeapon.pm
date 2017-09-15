package Jikkoku::Class::Skill::Role::HasWeapon {

  use Mouse::Role;
  use Jikkoku;
  
  requires qw( ACQUIRE_SIGN WEAPON_NAME );

  sub is_acquired {
    my $self = shift;
    $self->chara->weapon->skill == $self->ACQUIRE_SIGN;
  }

  sub acquire {
    my $self = shift;
    $self->chara->weapon->skill($self->ACQUIRE_SIGN);
  }

  around description_of_acquire_body => sub {
    my ($orig, $self) = @_;
    '武器 : ' . $self->WEAPON_NAME . 'を装備していること。';
  };

}

1;

