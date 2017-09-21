package Jikkoku::Class::Skill::Role::HasGuard {

  use Mouse::Role;
  use Jikkoku;
  
  requires qw( ACQUIRE_SIGN GUARD_NAME );

  sub is_acquired {
    my $self = shift;
    $self->chara->guard->skill_id eq $self->ACQUIRE_SIGN;
  }

  sub acquire {
    my $self = shift;
    $self->chara->guard->skill_id($self->ACQUIRE_SIGN);
  }

  around description_of_acquire_body => sub {
    my ($orig, $self) = @_;
    '防具 : ' . $self->GUARD_NAME . 'を装備していること。';
  };

}

1;

