package Option::Option {

  use v5.14;
  use warnings;
  use Carp;
  
  sub new;

  sub exists {
    Carp::confess "few arguments" if @_ < 2;
    my ($self, $code) = @_;
    Carp::confess "please specify CodeRef" if ref $code ne 'CODE';
  }

  sub fold {
    my ($self, $code) = @_;
    Carp::confess 'few arguments' if @_ < 2;
    Carp::confess "please specify CodeRef" if ref $code ne 'CODE';
  }

  sub foreach {
    my ($self, $code) = @_;
    $self->yield($code);
    ();
  }

  sub flatten {}

  sub flat_map {
    my ($self, $code) = @_;
    $self->map($code)->flatten;
  }

  sub get {}

  sub get_or_else {
    Carp::confess "few arguments" if @_ < 2;
  }

  sub is_defined { not shift->is_empty }

  sub is_empty {}

  sub match {
    Carp::confess "few arguments" if @_ < 5;
    my ($self, %args) = @_;
    for (qw/Some None/) {
      my $code = $args{$_};
      Carp::confess " please specify process $_ " if ref $code ne 'CODE';
    }
  }

  sub map {
    Carp::confess "few arguments" if @_ < 2;
    my ($self, $code) = @_;
    Carp::confess "please specify CodeRef" if ref $code ne 'CODE';
  }

  sub to_list {}

  sub yield {
    Carp::confess "few arguments" if @_ < 2;
    my ($self, $code) = @_;
    Carp::confess "please specify CodeRef" if ref $code ne 'CODE';
  }

}

1;

__END__

=encoding utf8

=head1 NAME
  
  Option - Option base class like Scala.Option.

=cut

