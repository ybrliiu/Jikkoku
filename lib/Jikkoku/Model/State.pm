package Jikkoku::Model::State {

  use Mouse;
  use Jikkoku;

  use constant {
    NAMESPACE => 'Jikkoku::Class::State',
    ROLE      => 'Jikkoku::Class::State::State',
  };

  has 'chara' => ( is => 'ro', isa => 'Jikkoku::Class::Chara::ExtChara', weak_ref => 1, required => 1 );

  with 'Jikkoku::Model::Role::Class';

  sub get {
    my ($self, $id) = @_;
    "@{[ $self->NAMESPACE ]}::${id}"->new(chara => $self->chara);
  }

  __PACKAGE__->prepare;
  __PACKAGE__->meta->make_immutable;

}

package Jikkoku::Model::State::Result {

  use Mouse;
  use Jikkoku;
  use List::Util qw( sum );

  with 'Jikkoku::Model::Role::Result';

  has 'id_map' => (
    is      => 'ro',
    isa     => 'HashRef',
    lazy    => 1,
    default => sub {
      my $self = shift;
      +{ map { $_->id => $_ } @{ $self->data } };
    },
  );

  sub get {
    my ($self, $id) = @_;
    Carp::croak 'Too few arguments (required: $id)' if @_ < 2;
    $self->id_map->{$id} // Carp::croak "no such state($id)";
  }

  sub get_available_states_with_result {
    my ($self, $time) = @_;
    $time //= time;
    $self->create_result([ grep { $_->is_available($time) } @{ $self->data } ]);
  }

  sub get_move_cost_adjuster_states_with_result {
    my $self = shift;
    $self->create_result(
      [ grep { $_->DOES('Jikkoku::Class::State::Role::MoveCostAdjuster') } @{ $self->data } ]);
  }

  sub get_battle_action_success_ratio_adjuster_with_result {
    my $self = shift;
    $self->create_result([
      grep { $_->DOES('Jikkoku::Class::State::Role::BattleActionSuccessRatioAdjuster') }
        @{ $self->data }
    ]);
  }

  sub get_move_cost_overwriter_states_with_result {
    my ($self, $orig_move_cost) = @_;
    $self->create_result([
      grep { $_->DOES('Jikkoku::Class::BattleMap::Node::MoveCostOverwriter') }
        @{ $self->data } 
    ]);
  }

  sub get_chara_power_adjuster_states_with_result {
    my $self = shift;
    $self->create_result([
      grep { $_->DOES('Jikkoku::Service::BattleCommand::Battle::CharaPower::CharaPowerAdjuster') }
        @{ $self->data }
    ]);
  }

  sub get_enemy_power_adjuster_states_with_result {
    my $self = shift;
    $self->create_result([
      grep { $_->DOES('Jikkoku::Service::BattleCommand::Battle::CharaPower::EnemyPowerAdjuster') }
        @{ $self->data }
    ]);
  }

  __PACKAGE__->meta->make_immutable;

};

1;

