package Jikkoku::Service::Skill::Role::UsedInBattleMap {

  use Mouse::Role;
  use Jikkoku;

  with 'Jikkoku::Service::Role::BattleAction';

  # attribute
  requires qw( log_color );

  before ensure_can_exec => sub {
    my $self = shift;
    unless ( $self->skill->is_acquired ) {
      Jikkoku::Service::Role::BattleActionException
        ->throw( $self->skill->name . 'スキルを修得していません。' );
    }
  };

}

1;
