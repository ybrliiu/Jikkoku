package Jikkoku::Model::Chara::BattleActionReservation {
  
  use Mouse;
  use Jikkoku;

  use constant INFLATE_TO => 'Jikkoku::Model::Chara::BattleActionReservationRecord';

  with 'Jikkoku::Model::Role::Division';

  around create => sub {
    my ($orig, $self, $id) = @_;
    Carp::croak 'Too few arguments (required: $id)' if @_ < 3;
    $self->$orig({
      id            => $id,
      data          => [ ($self->INFLATE_TO->EMPTY_DATA) x $self->INFLATE_TO->MAX ],
      textdata_list => [],
    });
  };

  __PACKAGE__->prepare;
  __PACKAGE__->meta->make_immutable;

}

package Jikkoku::Model::Chara::BattleActionReservation::Result {

  use Mouse;
  use Jikkoku;

  has 'id_map' => (
    is      => 'ro',
    isa     => 'HashRef[Jikkoku::Model::Chara::BattleActionReservationRecord]',
    lazy    => 1,
    default => sub {
      my $self = shift;
      +{ map { $_->id => $_ } @{ $self->data } };
    },
  );

  with 'Jikkoku::Model::Role::Result';

  sub get {
    my ($self, $id) = @_;
    Carp::croak 'Too few arguments (required: $id)' if @_ < 2;
    $self->id_map->{$id};
  }

  __PACKAGE__->meta->make_immutable;

}

1;
