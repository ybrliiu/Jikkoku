package Jikkoku::Class::Skill::BattleMethod::BattleMethod {

  use Mouse::Role;
  use Jikkoku;
  
  requires qw( ACQUIRE_SIGN );

  with qw(
    Jikkoku::Class::Skill::Skill
    Jikkoku::Class::Skill::Role::Purchasable
    Jikkoku::Class::Skill::Role::DependOnAbilities
  );

  sub depend_abilities { ['force'] }

  sub _build_items_of_depend_on_abilities { [] }

  sub is_acquired {
    my $self = shift;
    $self->chara->_skill->get('battle_method') =~ /(??{ $self->ACQUIRE_SIGN })/;
  }

  sub acquire {
    my $self = shift;
    $self->chara->_skill->set(battle_method => ':' . $self->ACQUIRE_SIGN);
  }

}

1;

