package Jikkoku::Class::Skill::Role::UsedInBattleMap::DependOnAbilities {

  use Mouse::Role;
  use Jikkoku;
  use Carp;

  with 'Jikkoku::Class::Skill::Role::DependOnAbilities';

  # attribute
  requires qw(
    success_ratio
    max_success_ratio
    min_effect_time_ratio
    max_effect_time_ratio
  );

  around description_of_status_about_success_ratio => sub {
    my ($orig, $self) = @_;
    "成功率 : <strong>@{[ $self->calc_success_ratio( $self->depend_abilities_sum ) * 100 ]}</strong>%";
  };

  around description_of_effect_supplement => sub {
    my ($orig, $self) = @_;
    my $ability_sum = $self->depend_abilities_sum;
    my ($min_effect_time, $max_effect_time) = $self->effect_time($ability_sum);
    "効果持続時間は<strong>${min_effect_time}</strong>秒〜<strong>${max_effect_time}</strong>秒。";
  };

  sub depend_abilities_sum {
    my $self = shift;
    List::Util::sum map { $self->chara->$_ } @{ $self->depend_abilities };
  }

  sub calc_success_ratio {
    my ($self, $ability_sum) = @_;
    Carp::confess 'Too few arguments ($ability_sum)' if @_ < 2;
    my $probability = $ability_sum * $self->success_ratio;
    $probability > $self->max_success_ratio ? $self->max_success_ratio : $probability;
  }

  sub effect_time {
    my ($self, $ability_sum) = @_;
    Carp::croak 'Too few arguments ($ability_sum)' if @_ < 2;
    int($ability_sum * $self->min_effect_time_ratio), int($ability_sum * $self->max_effect_time_ratio);
  }

}

1;
