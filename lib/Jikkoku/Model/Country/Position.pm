package Jikkoku::Model::Country::Position {

  use Mouse;
  use Jikkoku;

  use constant {
    INFLATE_TO       => 'Country::Position',
    CONFIG_FILE_NAME => 'country_position',
  };

  has 'id_map' => (
    is      => 'ro',
    isa     => 'HashRef[Jikkoku::Class::Country::Position]',
    lazy    => 1,
    builder => '_build_id_map',
  );

  with 'Jikkoku::Model::Role::ConfigToObject';

  sub _build_id_map {
    my $self = shift;
    +{ map { $_->id => $_ } @{ $self->data } };
  }

  sub get {
    my ($self, $id) = @_;
    Carp::croak 'few arguments (id)' if @_ < 2;
    $self->id_map->{$id} // Carp::confess "no such id data ($id)";
  }

  sub get_headquarters {
    my $self = shift;
    [ grep { $_->is_headquarters } @{ $self->data } ];
  }

  __PACKAGE__->meta->make_immutable;

}

1;

