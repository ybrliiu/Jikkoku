package Jikkoku::Class::Skill::Role::UsedInBattleMap::OccurActionTime {

  use Mouse::Role;
  use Jikkoku;

  with 'Jikkoku::Class::Role::BattleAction::OccurActionTime';

  # attribute
  requires 'action_interval_time';

  around explain_status => sub {
    my ($orig, $self) = (shift, shift);
    $self->$orig(@_) . "待機時間 : @{[ $self->action_interval_time ]}秒<br>";
  };

}

1;

