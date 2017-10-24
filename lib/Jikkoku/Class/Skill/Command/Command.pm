package Jikkoku::Class::Skill::Command::Command {

  use Mouse::Role;
  use Jikkoku;
  
  requires qw( ACQUIRE_SIGN );

  with qw(
    Jikkoku::Class::Skill::Skill
    Jikkoku::Class::Skill::Role::Purchasable
    Jikkoku::Class::Skill::Role::DependOnAbilities
  );

  sub depend_abilities { ['leadership'] }

  sub _build_items_of_depend_on_abilities { [] }

  sub is_acquired {
    my $self = shift;
    $self->chara->_skill->get('command') =~ /(??{ $self->ACQUIRE_SIGN })/;
  }

  sub acquire {
    my $self = shift;
    $self->chara->_skill->set(command => ':' . $self->ACQUIRE_SIGN);
  }

}

1;

