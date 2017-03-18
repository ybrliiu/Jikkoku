package Jikkoku::Class::Skill::Role::UsedInBattleMap::Purchasable {

  use Mouse::Role;
  use Jikkoku;

  with 'Jikkoku::Class::Skill::Role::Purchasable';

  around explain_effect_simple => sub {
    my ($orig, $self) = (shift, shift);
    $self->$orig(@_) . '消費士気' . $self->consume_morale . '。(行動)';
  };

}

1;

