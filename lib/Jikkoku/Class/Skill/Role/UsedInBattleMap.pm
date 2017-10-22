package Jikkoku::Class::Skill::Role::UsedInBattleMap {

  use Mouse::Role;
  use Jikkoku;

  with qw( Jikkoku::Class::Skill::Role::InBattleMap );

  # attribute
  requires qw( consume_morale );

  # method
  requires qw( effect_time );

  around description_of_status_about_consume_morale => sub {
    my ($orig, $self) = @_;
    "消費士気 : @{[ $self->consume_morale ]}";
  };

}

1;

__END__

Jikkoku::Class::Skill::Skill
+ Jikkoku::Class::Skill::Role::DependOnAbilities

