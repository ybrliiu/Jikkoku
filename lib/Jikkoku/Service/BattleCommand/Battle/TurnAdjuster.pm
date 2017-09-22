package Jikkoku::Service::BattleCommand::Battle::TurnAdjuster {

  use Mouse::Role;
  use Jikkoku;

  requires qw( adjust_battle_turn );

}

1;

__END__

=head1

sub adjust_battle_turn($self): Int;

=cut
