package Jikkoku::Class::Skill::Role::UsedInBattleMap::DependOnAbilities {

  use Mouse::Role;
  use Jikkoku;
  use Carp;
  use List::Util ();

  with qw( Jikkoku::Class::Skill::Role::DependOnAbilities );

  # attribute
  requires qw(
    success_ratio
    max_success_ratio
  );

  has 'depend_abilities_sum' => ( is => 'ro', isa => 'Int', lazy => 1, builder => '_build_depend_abilities_sum' );

  sub _build_depend_abilities_sum {
    my $self = shift;
    List::Util::sum map { $self->chara->$_ } @{ $self->depend_abilities };
  }

  around description_of_status_about_success_ratio => sub {
    my ($orig, $self) = @_;
    "成功率 : <strong>@{[ $self->calc_success_ratio( $self->depend_abilities_sum ) * 100 ]}</strong>%";
  };

  sub calc_success_ratio {
    my $self = shift;
    my $probability = $self->depend_abilities_sum * $self->success_ratio;
    $probability > $self->max_success_ratio ? $self->max_success_ratio : $probability;
  }

}

1;
