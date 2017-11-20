package Either::Either {

  use v5.14;
  use warnings;
  use parent 'Either::Projection';

  use Carp ();
  use Option::Some;
  use Option::None;
  use Either::LeftProjection;
  use Either::RightProjection;

  # override
  sub _content { $_[0]->{content} }

  # override
  sub _is_available { $_[0]->is_right }

  # override
  sub filter {
    my ($self, $code) = @_;
    my $result = $self->exists($code);
    $result ? Option::Some->new($self) : Option::None->new;
  }

  # override
  sub flat_map {
    my ($self, $code) = @_;
    $self->map($code)->join_right;
  }

  sub fold { Carp::croak 'you must define fold method.' }

  sub is_left() { Carp::croak 'you must define is_left method.' }

  sub is_right() { Carp::croak 'you must define is_right method.' }

  sub join_left { Carp::croak 'you must define join_left method.' }

  sub join_right { Carp::croak 'you must define join_right method.' }

  sub left {
    my $self = shift;
    Either::LeftProjection->new($self);
  }

  sub merge {
    my $self = shift;
    $self->{content};
  }

  sub match {
    Carp::confess "few arguments" if @_ < 5;
    my ($self, %args) = @_;
    for (qw/ Right Left /) {
      my $code = $args{$_};
      Carp::confess " please specify process $_ " if ref $code ne 'CODE';
    }
  }

  sub right {
    my $self = shift;
    Either::RightProjection->new($self);
  }

  sub swap { Carp::croak 'you must define swap method.' }

}

1;

