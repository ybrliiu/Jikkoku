package Jikkoku::Class::Skill::Role::UsedInBattleMap::Purchasable {

  use Mouse::Role;
  use Jikkoku;

  with 'Jikkoku::Class::Skill::Role::Purchasable';

  around explain_effect_about_consume_morale => sub {
    my ($orig, $self) = (shift, shift);
    "消費士気@{[ $self->consume_morale ]}。";
  };

}

1;

