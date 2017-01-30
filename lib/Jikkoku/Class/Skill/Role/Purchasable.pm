package Jikkoku::Class::Skill::Role::Purchasable {

  use Mouse::Role;
  use Jikkoku;

  requires qw( consume_skill_point );

  requires qw( explain_effect_simple );

  around acquire => sub {
    my ($orig, $self) = @_;
    $self->$orig();
    $self->chara->skill_point( $self->chara->skill_point - $self->consume_skill_point );
  };

}

1;
