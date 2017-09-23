package Jikkoku::Service::BattleCommand::Battle::OccurActionTimeOverwriter {

  use Mouse::Role;
  use Jikkoku;

  requires qw( overwrite_battle_occur_action_time );

}

1;

__END__

=head1

sub overwrite_battle_occur_action_time($self, $orig_battle_occur_action_time)

=cut

