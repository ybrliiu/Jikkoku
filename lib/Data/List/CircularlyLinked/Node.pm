package Data::List::CircularlyLinked::Node {

  use v5.14;
  use warnings;
  use Carp ();
  use Scalar::Util ();
  use Class::Accessor::Lite (
    new => 0,
    rw  => [qw/next/],
  );
  use overload (
    '0+'  => \&body,
    q{""} => \&body,
    fallback => 1,
  );

  sub new {
    my ($class, %args) = @_;
    Carp::croak "please spicefy body value." unless exists $args{body};
    state $default = +{
      body => undef,
      next => undef,
    };
    bless {
      %$default,
      %args,
    }, $class;
  }

  # overload が変な動きするので, newに書けない
  sub weak_next {
    my $self = shift;
    Scalar::Util::weaken $self->{next};
  }

  sub body {
    my ($self, $value) = @_;
    if (defined $value) {
      $self->{body} = $value;
    }
    $self->{body};
  }

}

1;
