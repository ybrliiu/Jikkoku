package Jikkoku::Service::BattleCommand::Battle::BattleLoop::EventExecuteService {

  use Mouse::Role;
  use Jikkoku;

  has 'event_executer' => (
    is       => 'ro',
    does     => 'Jikkoku::Service::BattleCommand::Battle::BattleLoop::EventExecuter',
    required => 1,
  );

  has 'battle_loop' => (
    is       => 'ro',
    isa      => 'Jikkoku::Service::BattleCommand::Battle::BattleLoop',
    handles  => [qw/ chara target distance /],
    required => 1,
  );

  has 'is_reach' => ( is => 'ro', isa => 'Bool', lazy => 1, builder => '_build_is_reach' );

 # 引数で値かえられるように
  has 'occur_ratio' => ( is => 'ro', isa => 'Num', lazy => 1, builder => '_build_occur_ratio' );

  requires qw( exec_event );

  sub _build_is_reach {
    my $self = shift;
    $self->battle_loop->distance <= $self->event_executer->range;
  }

  sub _build_occur_ratio {
    my $self = shift;
    $self->event_executer->occur_ratio;
  }

  sub can_exec_event {
    my $self = shift;
    $self->occur_ratio > rand 1 && $self->is_reach;
  }

  around exec_event => sub {
    my ($orig, $self) = @_;
    if ( $self->can_exec_event ) {
      $self->$orig();
    }
  };

}

1;

__END__

