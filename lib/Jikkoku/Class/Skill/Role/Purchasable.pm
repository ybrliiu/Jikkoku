package Jikkoku::Class::Skill::Role::Purchasable {

  use Mouse::Role;
  use Jikkoku;

  # attribute
  requires qw( consume_skill_point );

  # method
  requires qw( explain_effect_simple );

  around acquire => sub {
    my ($orig, $self) = @_;
    $self->$orig();
    $self->chara->skill_point( $self->chara->skill_point - $self->consume_skill_point );
  };

  around explain_acquire => sub {
    my ($orig, $self) = (shift, shift);
    $self->$orig(@_) . 'スキル修得ページでSPを' . $self->consume_skill_point . '消費して修得。<br>';
  };

}

1;
