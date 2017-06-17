package Jikkoku::Service::Skill::Role::UsedInBattleMap::DependOnAbilities {

  use Mouse::Role;
  use Jikkoku;
  use Carp;

  sub calc_success_ratio {
    my ($self, $ability_sum) = @_;
    Carp::confess 'few arguments ($ability_sum)' if @_ < 2;
    $self->skill->calc_success_ratio($ability_sum);
  }

  sub calc_effect_time {
    my ($self, $ability_sum) = @_;
    Carp::croak 'few arguments($ability_sum)' if @_ < 2;
    my ($min_effect_time, $max_effect_time) = $self->skill->effect_time($ability_sum);
    $min_effect_time + int( rand $max_effect_time - $min_effect_time );
  }

}

1;
