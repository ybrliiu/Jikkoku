package Option::Some {

  use v5.14;
  use warnings;
  use parent 'Option::Option';

  # override
  sub new {
    Carp::confess "few arguments" if @_ < 2;
    my ($class, $data) = @_;
    # Scala では null を許容するが、このモジュールでは許容しない
    Carp::confess "cant use undefined value at $class" unless defined $data;
    bless +{ contents => $data }, $class;
  }

  # override
  sub exists {
    my ($self, $code) = @_;
    $self->SUPER::exists($code);
    local $_ = $self->{contents};
    $code->( $self->{contents} );
  }

  # override
  sub fold {
    my ($self, $none) = @_;
    $self->SUPER::fold($none);
    sub {
      my $code = shift;
      Carp::confess "please specify CodeRef" if ref $code ne 'CODE';
      local $_ = $self->{contents};
      $code->( $self->{contents} );
    };
  }

  # override
  sub flatten {
    my $self = shift;
    $self->{contents}->isa('Option::Option') ? $self->{contents} : Carp::croak '$self->{contents} is not Option value';
    # $self->{contents}->isa('Option::Option') ? $self->{contents}->flatten : $self;
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
  sub is_empty { 0 }

  # override
  sub map {
    my ($self, $code) = @_;
    $self->SUPER::map($code);
    local $_ = $self->{contents};
    my $ret = $code->( $self->{contents} );
    Option::Some->new($ret);
  }

  # override
  sub match {
    my ($self, %args) = @_;
    local $_ = $self->{contents};
    $self->SUPER::match(%args);
    $args{Some}->( $self->{contents} );
  }

  # override
  sub to_list {
    my $self = shift;
    if ( $self->{contents}->isa('Option::Option') ) {
      ($self->{contents}, $self->{contents}->to_list);
    } else {
      ();
    }
  }

  # override
  sub yield {
    my ($self, $code) = @_;
    local $_ = $self->{contents};
    $self->SUPER::yield($code);
    # NOTE : in Scala, for - yield 
    $code->( $self->{contents} );
  }

}

1;

