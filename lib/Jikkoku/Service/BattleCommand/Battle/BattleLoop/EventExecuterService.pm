package Jikkoku::Service::BattleCommand::Battle::BattleLoop::EventExecuterService {

  use Mouse::Role;
  use Jikkoku;

  has 'event_executer' => (
    is       => 'ro',
    does     => 'Jikkoku::Service::BattleCommand::Battle::BattleLoop::EventExecuterService',
    handles  => [qw/ occur_ratio /],
    required => 1,
  );

  has 'battle_loop' => (
    is       => 'ro',
    isa      => 'Jikkoku::Service::BattleCommand::Battle::BattleLoop',
    handles  => [qw/ chara target /],
    required => 1,
  );

  requires qw( exec_event );

  sub can_exec_event {
    my $self = shift;
    $self->occur_ratio > rand 1;
  }

}

1;

__END__

