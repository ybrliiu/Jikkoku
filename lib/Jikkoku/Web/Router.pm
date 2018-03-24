package Jikkoku::Web::Router {

  use Mouse;
  use Jikkoku;

  use Carp;
  use Jikkoku::Util qw( validate_values );
  use Router::Boom::Method;
  use Jikkoku::Web::Router::Root;

  has 'router_method' => (
    is      => 'ro',
    isa     => 'Router::Boom::Method',
    default => sub { Router::Boom::Method->new },
    handles => [qw/ add /],
  );

  sub match {
    my ($self, $http_method, $path_info) = @_;
    Carp::croak "引数が足りません" if @_ < 3;

    my ($dest, $captured, $is_method_not_allowed) = $self->router_method->match($http_method, $path_info);
    my $is_method_allowed = not $is_method_not_allowed;

    my ($last_uri) = ($path_info =~ m!([^/]+$)!);
    if ( exists $dest->{controller} and not exists $dest->{action} ) {
      $dest->{action} = $last_uri ? $last_uri =~ s/-/_/gr : 'root';
    }
    
    ($dest, $captured, $is_method_allowed);
  }

  sub get {
    my $self = shift;
    $self->add('GET', @_);
  }

  sub post {
    my $self = shift;
    $self->add('POST', @_);
  }

  sub any {
    my $self = shift;
    $self->add([qw/ GET POST /], @_);
  }

  sub root {
    my ($self, %args) = @_;
    validate_values \%args => [qw/ path controller /];
    Jikkoku::Web::Router::Root->new(
      router     => $self,
      path       => $args{path},
      controller => $args{controller},
    );
  }

  __PACKAGE__->meta->make_immutable;

}

1;
