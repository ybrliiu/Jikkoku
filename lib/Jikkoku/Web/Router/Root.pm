package Jikkoku::Web::Router::Root {

  use Jikkoku;
  use Mouse;

  use Carp;
  use Jikkoku::Util qw( validate_values );

  has 'path'       => ( is => 'ro', isa => 'Str', required => 1 );
  has 'router'     => ( is => 'ro', isa => 'Jikkoku::Web::Router', required => 1 );
  has 'controller' => ( is => 'ro', required => 1 );

  sub root {
    my ($self, %args) = @_;
    validate_values \%args => [qw/ path controller /];
    __PACKAGE__->new(
      router     => $self->router,
      path       => $self->path . $args{path},
      controller => $self->controller . '::' . $args{controller},
    );
  }

  sub any {
    my ($self, $path) = @_;
    Carp::croak 'Too few arguments (required: $path)' if @_ < 2;
    $self->router->any("$self->{path}${path}", +{ controller => $self->controller });
  }

  __PACKAGE__->meta->make_immutable;

}

1;
