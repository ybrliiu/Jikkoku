package Option::None {

  use v5.14;
  use warnings;
  use parent 'Option';
  use Option::NoSuchElementException;

  # override
  sub new {
    my $class = shift;
    $class->SUPER::new(undef);
  }

  # override
  sub get {
    Option::NoSuchElementException->throw;
  }

  # override
  sub get_or_else {
    my ($self, $default_value) = @_;
    $self->SUPER::get_or_else($default_value);
    $default_value;
  }

  # override
  sub is_defined { 0 }

  # override
  sub is_empty { 1 }

  # override
  sub match {
    my ($self, %args) = @_;
    $self->SUPER::match(%args);
    $args{None}->();
  }

}

1;
