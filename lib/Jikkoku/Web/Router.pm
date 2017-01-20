package Jikkoku::Web::Router {

  use Jikkoku;
  use parent 'Router::Boom::Method';

  use Carp;
  use Jikkoku::Web::Router::Root;

  use Jikkoku::Util qw/validate_values/;

  # override
  sub match {
    my ($self, $http_method, $path_info) = @_;
    Carp::croak "引数が足りません" if @_ < 3;

    my ($dest, $captured, $is_method_not_allowed) = $self->SUPER::match($http_method, $path_info);
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
    $self->add([qw/GET POST/], @_);
  }

  sub root {
    my ($self, %args) = @_;
    validate_values \%args => [qw/path controller/];
    Jikkoku::Web::Router::Root->new(
      router     => $self,
      path       => $args{path},
      controller => $args{controller},
    );
  }

}

1;
