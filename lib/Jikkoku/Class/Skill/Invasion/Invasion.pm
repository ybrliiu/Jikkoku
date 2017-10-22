package Jikkoku::Class::Skill::Invasion::Invasion {

  use Mouse::Role;
  use Jikkoku;

  requires qw( ACQUIRE_SIGN );

  with qw(
    Jikkoku::Class::Skill::Skill
    Jikkoku::Class::Skill::Role::Purchasable
    Jikkoku::Class::Skill::Role::RequireAbilities
  );

  sub is_acquired {
    my $self = shift;
    $self->chara->skill('invasion') =~ /(??{ $self->ACQUIRE_SIGN })/;
  }

  sub acquire {
    my $self = shift;
    $self->chara->skill( invasion => $self->chara->skill('invasion') . ':' . $self->ACQUIRE_SIGN );
  }

  around is_available => sub {
    my ($orig, $self) = @_;
    $self->$orig() && $self->chara->is_invasion && $self->chara->force >= $self->REQUIRE_ABILITIES->{force};
  };

}

1;

