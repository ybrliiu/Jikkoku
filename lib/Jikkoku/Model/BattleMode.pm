package Jikkoku::Model::BattleMode {

  use Mouse;
  use Jikkoku;

  use constant {
    ROLE      => 'Jikkoku::Class::BattleMode::BattleMode',
    NAMESPACE => 'Jikkoku::Class::BattleMode',
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

package Jikkoku::Model::BattleMode::Result {

  use Mouse;
  use Jikkoku;

  with 'Jikkoku::Model::Role::Result';

  has 'id_map' => (
    is      => 'ro',
    isa     => 'HashRef[Jikkoku::Class::BattleMode::BattleMode]',
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

  __PACKAGE__->meta->make_immutable;

};


1;

