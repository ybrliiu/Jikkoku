package Jikkoku::Model::Chara::Command {
  
  use Mouse;
  use Jikkoku;

  use constant INFLATE_TO => 'Jikkoku::Model::Chara::CommandRecord';

  with 'Jikkoku::Model::Role::Division';

  around create => sub {
    my ($orig, $self, $id) = @_;
    Carp::croak 'few arguments($id)' if @_ < 3;
    $self->$orig({
      id            => $id,
      data          => [ ($self->INFLATE_TO->EMPTY_DATA) x $self->INFLATE_TO->MAX ],
      textdata_list => [],
    });
  };

  __PACKAGE__->prepare;
  __PACKAGE__->meta->make_immutable;

}

package Jikkoku::Model::Chara::Command::Result {

  use Mouse;
  use Jikkoku;

  has 'id_map' => (
    is      => 'ro',
    isa     => 'HashRef[Jikkoku::Model::Chara::CommandRecord]',
    lazy    => 1,
    default => sub {
      my $self = shift;
      +{ map { $_->id => $_ } @{ $self->data } };
    },
  );

  with 'Jikkoku::Model::Role::Result';

  sub get {
    my ($self, $id) = @_;
    Carp::croak 'few arguments($id)' if @_ < 2;
    $self->id_map->{$id};
  }

  __PACKAGE__->meta->make_immutable;

}

1;
