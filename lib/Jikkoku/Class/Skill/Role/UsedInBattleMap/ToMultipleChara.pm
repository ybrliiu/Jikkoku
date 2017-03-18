package Jikkoku::Class::Skill::Role::UsedInBattleMap::ToMultipleChara {

  use Mouse::Role;
  use Jikkoku;

  around explain_status => sub {
    my ($orig, $self) = (shift, shift);
    $self->$orig(@_) . "効果範囲 : @{[ $self->range ]}";
  };

}

1;
