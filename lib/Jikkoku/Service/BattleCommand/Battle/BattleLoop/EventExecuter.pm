package Jikkoku::Service::BattleCommand::Battle::BattleLoop::EventExecuter {

  use Mouse::Role;
  use Jikkoku;

  requires qw( exec_event );

}

1;

__END__

=head1

sub exec_event($self, $battle_loop)

=cut

