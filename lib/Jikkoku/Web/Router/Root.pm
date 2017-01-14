package Jikkoku::Web::Router::Root {

  use Jikkoku;
  use Jikkoku::Util qw/validate_values/;
  
  sub new {
    my ($class, %args) = @_;
    validate_values \%args => [qw/router path controller/];
    bless \%args, $class;
  }

  sub root {
    my ($self, %args) = @_;
    validate_values \%args => [qw/path controller/];
    __PACKAGE__->new(
      router     => $self->{router},
      path       => $self->{path} . $args{path},
      controller => $self->{controller} . '::' . $args{controller},
    );
  }

  sub any {
    my ($self, $path) = @_;
    warn $self->{controller};
    $self->{router}->any("$self->{path}${path}", +{ controller => $self->{controller} });
  }

}

1;
