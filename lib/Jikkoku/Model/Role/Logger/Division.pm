package Jikkoku::Model::Role::Logger::Division {

  use Mouse::Role;
  use Jikkoku;

  with qw( Jikkoku::Model::Role::Division );

  sub create {
    my ($self, $id) = @_;
    Carp::croak 'Too few arguments (required: $id)' if @_ < 2;
    $self->INFLATE_TO->new(
      id   => $id,
      data => [],
    )->init;
  }

}

1;

