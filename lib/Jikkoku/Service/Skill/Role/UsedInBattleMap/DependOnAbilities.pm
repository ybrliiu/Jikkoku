package Jikkoku::Service::Skill::Role::UsedInBattleMap::DependOnAbilities {

  use Mouse::Role;
  use Jikkoku;
  use Carp;

  around calc_success_ratio => sub {
    my ($orig, $self, $ability_sum) = @_;
    Carp::confess 'few arguments ($ability_sum)' if @_ < 3;
    my $skill = $self->skill;
    my $probability = $ability_sum * $skill->success_coef;
    $probability > $skill->max_success_ratio ? $skill->max_success_ratio : $probability;
  };

  sub calc_effect_time {
    my ($self, $ability_sum) = @_;
    Carp::croak 'few arguments($ability_sum)' if @_ < 2;
    my ($min_effect_time, $max_effect_time) = $self->skill->effect_time($ability_sum);
    $min_effect_time + int( rand $max_effect_time - $min_effect_time );
  }

}

1;
