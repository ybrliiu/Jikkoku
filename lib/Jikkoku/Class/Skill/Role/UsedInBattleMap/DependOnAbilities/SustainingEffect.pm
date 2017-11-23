package Jikkoku::Class::Skill::Role::UsedInBattleMap::DependOnAbilities::SustainingEffect {

  use Mouse::Role;
  use Jikkoku;
  use Carp;

  with qw(
    Jikkoku::Class::Skill::Role::UsedInBattleMap::SustainingEffect
    Jikkoku::Class::Skill::Role::UsedInBattleMap::DependOnAbilities
  );

  # attribute
  requires qw(
    min_effect_time_ratio
    max_effect_time_ratio
  );

  around description_of_effect_supplement => sub {
    my ($orig, $self) = @_;
    my $ability_sum = $self->depend_abilities_sum;
    my ($min_effect_time, $max_effect_time) = $self->effect_time($ability_sum);
    "効果持続時間は<strong>${min_effect_time}</strong>秒〜<strong>${max_effect_time}</strong>秒。";
  };

  sub effect_time {
    my $self = shift;
    int($self->depend_abilities_sum * $self->min_effect_time_ratio),
    int($self->depend_abilities_sum * $self->max_effect_time_ratio);
  }

}

1;

__END__

効果が持続するスキル向けのRole
