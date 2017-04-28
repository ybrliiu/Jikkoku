package Jikkoku::Class::Skill::Role::UsedInBattleMap::OccurActionTime {

  use Mouse::Role;
  use Jikkoku;

  with 'Jikkoku::Class::Role::BattleAction::OccurActionTime';

  # attribute
  requires 'action_interval_time';

  around description_of_action_interval_time => sub {
    my ($orig, $self) = @_;
    "待機時間 : @{[ $self->action_interval_time ]}秒";
  };

}

1;

