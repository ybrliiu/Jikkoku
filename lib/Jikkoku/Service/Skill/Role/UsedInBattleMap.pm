package Jikkoku::Service::Skill::Role::UsedInBattleMap {

  use Mouse::Role;
  use Jikkoku;

  with qw(
    Jikkoku::Service::Skill::Skill
    Jikkoku::Service::Role::BattleAction
  );

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

__END__

=head2 ACCESSORS

=head3 C<skill : Jikkoku::Class::Skill::Role::UsedInBattleMap>

=cut
