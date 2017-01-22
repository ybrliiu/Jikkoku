package Option::Some {

  use v5.14;
  use warnings;
  use parent 'Option';

  # override
  sub new {
    my ($class, $data) = @_;
    my $self = $class->SUPER::new($data);
    Carp::confess "cant use undefined value at $class" unless defined $data;
    $self;
  }

  # override
  sub foreach {
    my ($self, $code) = @_;
    $self->SUPER::foreach($code);
    # NOTE : in Scala, return value is empty tuple ( () )
    #        in this module, return value is desided by $code
    local $_ = $self->{contents};
    $code->( $self->{contents} );
  }

  # override
  sub get { shift->{contents} }

  # override
  sub get_or_else {
    my ($self, $default_value) = @_;
    $self->SUPER::get_or_else($default_value);
    $self->{contents};
  }

  # override
  sub is_defined { 1 }

  # override
  sub is_empty { 0 }

  # override
  sub match {
    my ($self, %args) = @_;
    $self->SUPER::match(%args);
    local $_ = $self->{contents};
    $args{Some}->( $self->{contents} );
  }

}

1;

