package Jikkoku::Class::Skill::Role::Purchasable {

  use Mouse::Role;
  use Jikkoku;

  # attribute
  requires qw( consume_skill_point );

  {
    my @methods = qw(
      description_of_effect_about_state
      description_of_effect_body
      description_of_effect_about_depend_abilities
      description_of_effect_about_consume_morale
      description_of_effect_about_is_action
    );

    sub description_of_effect_about_is_action { '' }

    sub description_of_effect_about_consume_morale { '' }

    sub description_of_effect_simple {
      my $self = shift;
      join "<br>\n", grep { $_ ne '' } map { $self->$_ } @methods;
    }
  }

  around acquire => sub {
    my ($orig, $self) = @_;
    $self->$orig();
    $self->chara->skill_point( $self->chara->skill_point - $self->consume_skill_point );
  };

  around description_of_acquire_about_purchase => sub {
    my ($orig, $self) = (shift, shift);
    'スキル修得ページでSPを' . $self->consume_skill_point . '消費して修得。';
  };

}

1;
