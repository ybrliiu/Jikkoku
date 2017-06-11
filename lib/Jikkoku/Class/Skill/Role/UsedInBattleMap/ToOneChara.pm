package Jikkoku::Class::Skill::Role::UsedInBattleMap::ToOneChara {

  use Mouse::Role;
  use Jikkoku;
  use Jikkoku::Util;

  with 'Jikkoku::Class::Skill::Role::ToOneChara';
  
  # attribute
  requires 'range';

  around description_of_status_about_range => sub {
    my ($orig, $self) = @_;
    "リーチ : @{[ $self->range ]}";
  };

}

1;
