package Jikkoku::Class::Skill::AssistMove::AssistMove {

  use Mouse::Role;
  use Jikkoku;
  
  requires qw( ACQUIRE_SIGN );

  with qw(
    Jikkoku::Class::Skill::Skill
    Jikkoku::Class::Skill::Role::Purchasable
    Jikkoku::Class::Skill::Role::DependOnAbilities
  );

  sub depend_abilities { ['popular'] }

  sub is_acquired {
    my $self = shift;
    $self->chara->_skill->get('assist_move') =~ /(??{ $self->ACQUIRE_SIGN })/;
  }

  sub acquire {
    my $self = shift;
    $self->chara->_skill->set(assist_move => ':' . $self->ACQUIRE_SIGN);
  }

}

1;

