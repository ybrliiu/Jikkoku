package Jikkoku::Model::Role::ConfigToObject {

  use Mouse::Role;
  use Jikkoku;
  use Jikkoku::Model::Config;

  sub PRIMARY_ATTRIBUTE() { 'id' }

  # constant value
  requires 'CONFIG_FILE_NAME';

  has 'data' => (
    is      => 'ro',
    isa     => 'ArrayRef',
    lazy    => 1,
    builder => '_build_data',
  );

  has 'name_map' => (
    is      => 'ro',
    isa     => 'HashRef',
    lazy    => 1,
    builder => '_build_name_map',
  );

  with qw(
    Jikkoku::Model::Role::Base
    Jikkoku::Role::Singleton
    Jikkoku::Role::Loader
  );

  sub _build_data {
    my $self = shift;
    my $data = Jikkoku::Model::Config->get->{ $self->CONFIG_FILE_NAME };
    [ map { $self->create_treat_class($_) } @$data ];
  }

  sub _build_name_map {
    my $self = shift;
    +{ map { $_->name => $_ } @{ $self->data } };
  }

  sub get_all { $_[0]->data }

  sub create_treat_class {
    my ($self, $args) = @_;
    $self->class( $self->INFLATE_TO )->new($args);
  }

  sub get {
    my ($self, $id) = @_;
    Carp::croak 'few arguments (id)' if @_ < 2;
    $self->data->[$id] // Carp::confess "no such id data ($id)";
  }

  sub get_by_name {
    my ($self, $name) = @_;
    Carp::croak 'few arguments (name)' if @_ < 2;
    $self->name_map->{$name} // Carp::confess "no such name data ($name)";
  }

  sub get_with_option { Carp::croak 'cant call get_with_option' }

  sub delete { Carp::croak 'cant call delete' }

}

1;

