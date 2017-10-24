package Jikkoku::Service::BattleCommand::Battle::AdjustTurnCalculator {

  use Mouse;
  use Jikkoku;

  use List::Util qw( sum );
  use Jikkoku::Service::BattleCommand::Battle::TurnAdjusterService;

  has 'chara' => (
    is       => 'ro',
    isa      => 'Jikkoku::Class::Chara::ExtChara',
    required => 1,
  );

  has 'adjusters' => (
    is      => 'ro',
    isa     => 'ArrayRef[Jikkoku::Service::BattleCommand::Battle::TurnAdjusterService]',
    lazy    => 1,
    builder => '_build_adjusters',
  );

  sub _build_adjusters {
    my $self = shift;
    my @adjusters = map {
      my $adjuster = $_;
      Jikkoku::Service::BattleCommand::Battle::TurnAdjusterService->new({
        chara  => $self->chara,
        target => $self->target,
        adjuster => $adjuster,
      });
    } @{
      $self->chara->skills
        ->get_available_skills_with_result
        ->get_battle_turn_adjuster_skills_with_result
    };
    \@adjusters;
  }

  sub calc {
    my $self = shift;
    sum map { $_->adjust_battle_turn } @{ $self->adjusters }
  }

  sub write_to_log {
    my $self = shift;
    $_->write_to_log for @{ $self->adjusters };
  }

  __PACKAGE__->meta->make_immutable;

}

1;

