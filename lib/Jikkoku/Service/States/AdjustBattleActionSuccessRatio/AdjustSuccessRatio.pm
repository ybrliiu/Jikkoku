package Jikkoku::Service::States::AdjustBattleActionSuccessRatio::AdjustSuccessRatio {

  use Mouse;
  use Jikkoku;
  use List::Util qw( sum );

  use Jikkoku::Model::Chara;
  use Jikkoku::Service::State::AdjustBattleActionSuccessRatio::TakeBonusForGiver;

  has 'chara' => ( is => 'ro', isa => 'Jikkoku::Class::Chara::ExtChara', required => 1 );
  has 'time'  => ( is => 'ro', isa => 'Int', lazy => 1, default => sub { time } );
  has 'origin_success_ratio' => ( is => 'ro', isa => 'Num', required => 1 );

  has 'states'               => ( is => 'ro', isa => 'Jikkoku::Model::State::Result', lazy => 1, builder => '_build_states' );
  has 'adjust_success_ratio' => ( is => 'ro', isa => 'Num', lazy => 1, builder => '_build_adjust_success_ratio' );

  has 'chara_model' => (
    is      => 'ro',
    isa     => 'Jikkoku::Model::Chara',
    lazy    => 1,
    default => sub { Jikkoku::Model::Chara->new },
  );

  sub _build_states {
    my $self = shift;
    $self->chara->states
      ->get_available_states_with_result($self->time)
      ->get_battle_action_success_ratio_adjuster_with_result;
  }

  sub _build_adjust_success_ratio {
    my $self = shift;
    sum(
      map {
        my $state = $_;
        my $service = Jikkoku::Service::State::AdjustBattleActionSuccessRatio::TakeBonusForGiver->new({
          state       => $state,
          chara_model => $self->chara_model,
        });
        $service->exec;
        $state->adjust_battle_action_success_ratio( $self->origin_success_ratio );
      } @{ $self->states }
    ) // 0;
  }

  __PACKAGE__->meta->make_immutable;

}

1;

