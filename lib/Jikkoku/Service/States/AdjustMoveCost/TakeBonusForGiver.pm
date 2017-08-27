package Jikkoku::Service::States::AdjustMoveCost::TakeBonusForGiver {

  use Mouse;
  use Jikkoku;

  use Jikkoku::Model::Chara;
  use Jikkoku::Service::State::AdjustMoveCost::TakeBonusForGiver

  has 'adjust_move_cost_service' => (
    is       => 'ro',
    isa      => 'Jikkoku::Service::States::AdjustMoveCost::AdjustMoveCost',
    handles  => [qw/ states adjust_move_cost /],
    required => 1,
  );

  has 'chara_model' => (
    is      => 'ro',
    isa     => 'Jikkoku::Model::Chara',
    lazy    => 1,
    default => sub { Jikkoku::Model::Chara->new },
  );

  sub exec {
    my $self = shift;
    for my $state (@{ $self->states }) {
      my $service = Jikkoku::Service::State::AdjustMoveCost::TakeBonusForGiver->new({
        state       => $state,
        chara_model => $self->chara_model,
      });
      $service->exec;
    }
  }

  __PACKAGE__->meta->make_immutable;

}

1;

