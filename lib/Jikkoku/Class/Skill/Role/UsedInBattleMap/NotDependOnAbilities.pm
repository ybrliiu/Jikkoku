package Jikkoku::Class::Skill::Role::UsedInBattleMap::NotDependOnAbilities {

  use Mouse::Role;
  use Jikkoku;

  # attribute
  requires qw(
    success_ratio
    effect_time
  );

  around calc_success_ratio => sub {
    my ($orig, $self) = @_;
    $self->success_ratio;
  };

  sub calc_effect_time { shift->effect_time }

  around description_of_status_about_success_ratio => sub {
    my ($orig, $self) = @_;
    "成功率 : @{[ $self->success_ratio * 100 ]}%";
  };

}

1;
