package Jikkoku::Class::Skill::Role::UsedInBattleMap::OccurActionTime {

  use Mouse::Role;
  use Jikkoku;

  with qw( Jikkoku::Class::Skill::Role::UsedInBattleMap );

  # attribute
  requires qw( action_interval_time );

  around description_of_status_about_action_interval_time => sub {
    my ($orig, $self) = @_;
    "待機時間 : @{[ $self->action_interval_time ]}秒";
  };

}

1;

