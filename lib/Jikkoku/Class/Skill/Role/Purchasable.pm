package Jikkoku::Class::Skill::Role::Purchasable {

  use Mouse::Role;
  use Jikkoku;

  # attribute
  requires qw( consume_skill_point );

  {
    my @methods = qw(
      explain_effect_about_state
      explain_effect_body
      explain_effect_about_depend_abilities
      explain_effect_about_consume_morale
      explain_effect_is_action
    );

    sub explain_effect_is_action { '' }

    sub explain_effect_about_consume_morale { '' }

    sub explain_effect_simple {
      my $self = shift;
      join "<br>\n", grep { $_ ne '' } map { $self->$_ } @methods;
    }
  }

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
