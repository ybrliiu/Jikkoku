package Jikkoku::Service::States::AdjustMoveCost::AdjustMoveCost {

  use Mouse;
  use Jikkoku;
  use List::Util qw( sum );

  has 'origin_cost' => ( is => 'ro', isa => 'Num', required => 1 );
  has 'chara'       => ( is => 'ro', isa => 'Jikkoku::Class::Chara::ExtChara', required => 1 );
  has 'time'        => ( is => 'ro', isa => 'Int', lazy => 1, default => sub { time } );

  has 'states'           => ( is => 'ro', isa => 'Jikkoku::Model::State::Result', lazy => 1, builder => '_build_states' );
  has 'adjust_move_cost' => ( is => 'ro', isa => 'Num', lazy => 1, builder => '_build_adjust_move_cost' );

  sub _build_states {
    my $self = shift;
    $self->chara->states
      ->get_available_states_with_result($self->time)
      ->get_move_cost_adjuster_states_with_result;
  }

  sub _build_adjust_move_cost {
    my $self = shift;
    sum(map { $_->adjust_move_cost($self->origin_cost) } @{ $self->states }) // 0;
  }

  __PACKAGE__->meta->make_immutable;

}

1;

