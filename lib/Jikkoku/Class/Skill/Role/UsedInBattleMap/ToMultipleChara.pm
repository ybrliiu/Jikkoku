package Jikkoku::Class::Skill::Role::UsedInBattleMap::ToMultipleChara {

  use Mouse::Role;
  use Jikkoku;

  around description_of_range => sub {
    my ($orig, $self) = @_;
    "効果範囲 : @{[ $self->range ]}";
  };

}

1;
