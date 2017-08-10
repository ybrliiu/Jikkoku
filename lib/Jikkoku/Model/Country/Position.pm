package Jikkoku::Model::Country::Position {

  use Mouse;
  use Jikkoku;

  use constant {
    INFLATE_TO       => 'Country::Position',
    CONFIG_FILE_NAME => 'country_position',
  };

  has 'data' => (
    is      => 'ro',
    isa     => 'HashRef[Jikkoku::Class::Country::Position]',
    lazy    => 1,
    builder => '_build_data',
  );

  with 'Jikkoku::Model::Role::ConfigToObject';

  sub _build_data {
    my $self = shift;
    my $data = Jikkoku::Model::Config->get->{ $self->CONFIG_FILE_NAME };
    +{ map { $_->{id} => $self->create_treat_class($_) } values %$data };
  }

  sub get {
    my ($self, $id) = @_;
    Carp::croak 'few arguments (id)' if @_ < 2;
    $self->data->{$id} // Carp::confess "no such id data ($id)";
  }

  __PACKAGE__->meta->make_immutable;

}

1;

