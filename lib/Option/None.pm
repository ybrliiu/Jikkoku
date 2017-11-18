package Option::None {

  use v5.14;
  use warnings;
  use parent 'Option::Option';
  use Option::NoSuchElementException;

  # override
  sub new {
    my $class = shift;
    bless +{}, $class;
  }

  # override
  sub exists {
    my ($self, $code) = @_;
    $self->SUPER::exists($code);
    '';
  }

  # override
  sub fold {
    my ($self, $none) = @_;
    $self->SUPER::fold($none);
    sub {
      my $some = shift;
      Carp::confess "please specify CodeRef" if ref $some ne 'CODE';
      $none->();
    };
  }

  # override
  sub flatten {
    my $self = shift;
    $self;
  }

  # override
  sub get {
    Option::NoSuchElementException->throw;
  }

  # override
  sub get_or_else {
    my ($self, $default) = @_;
    $self->SUPER::get_or_else($default);
    $default;
  }

  # override
  sub is_empty { 1 }

  # override
  sub to_list { () }

  # override
  sub map {
    my ($self, $code) = @_;
    $self->SUPER::map($code);
    $self;
  }

  # override
  sub match {
    my ($self, %args) = @_;
    $self->SUPER::match(%args);
    $args{None}->();
  }

}

1;
