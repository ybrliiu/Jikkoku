package Jikkoku::Model::ExtensiveState {

  use Mouse;
  use Jikkoku;
  use Option;

  use constant {
    NAMESPACE => 'Jikkoku::Class::ExtensiveState',
    ROLE      => 'Jikkoku::Class::ExtensiveState::ExtensiveState',
  };

  has 'chara' => ( is => 'ro', isa => 'Jikkoku::Class::Chara::ExtChara', weak_ref => 1, required => 1 );

  has 'record_model' => (
    is      => 'ro',
    isa     => 'Jikkoku::Model::ExtensiveStateRecord', 
    lazy    => 1,
    default => sub {
      my $self = shift;
      $self->model('ExtensiveStateRecord')->new;
    },
  );

  has 'chara_model' => (
    is      => 'ro',
    isa     => 'Jikkoku::Model::Chara',
    lazy    => 1,
    default => sub {
      my $self = shift;
      $self->model('Chara')->new;
    },
  );

  has 'charactors' => (
    is      => 'ro',
    isa     => 'Jikkoku::Model::Chara::Result',
    lazy    => 1,
    default => sub {
      my $self = shift;
      $self->chara_model->get_all_with_result;
    },
  );

  with qw(
    Jikkoku::Model::Role::Class
    Jikkoku::Role::Loader
  );

  sub get {
    my ($self, $id) = @_;
    Carp::croak 'Too few arguments (required: $id)' if @_ < 2;
    "@{[ $self->NAMESPACE ]}::${id}"->new({
      chara         => $self->chara->chara,
      chara_soldier => $self->chara->soldier,
      charactors    => $self->charactors,
      record_model  => $self->record_model,
    });
  }

  __PACKAGE__->prepare;
  __PACKAGE__->meta->make_immutable;

}

package Jikkoku::Model::ExtensiveState::Result {

  use Mouse;
  use Jikkoku;
  use Option;

  with 'Jikkoku::Model::Role::Result';

  has 'id_map' => (
    is      => 'ro',
    isa     => 'HashRef[Jikkoku::Class::ExtensiveState::ExtensiveState]',
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

  sub get_with_option {
    my ($self, $id) = @_;
    Carp::croak 'Too few arguments (required: $id)' if @_ < 2;
    option $self->id_map->{$id};
  }

  sub get_receive_effect_states_with_result {
    my ($self, $time) = @_;
    $time //= time;
    $self->create_result([ grep { $_->is_receive_effect($time) } @{ $self->data } ]);
  }

  sub get_give_effect_states_with_result {
    my ($self, $time) = @_;
    $time //= time;
    $self->create_result([ grep { $_->is_give_effect($time) } @{ $self->data } ]);
  }

  sub override_battle_target {
    my ($self, $time) = @_;
    $time //= time;
    my @overrider = map  { $_->override_battle_target }
                    grep { $_->DOES('Jikkoku::Service::BattleCommand::Battle::TargetOverrider') }
                    @{ $self->data };
    $overrider[0] // ();
  }

  __PACKAGE__->meta->make_immutable;

};

1;

