package Either::Projection {

  use v5.14;
  use warnings;

  use Carp ();
  use Option;

  sub new { Carp::croak 'you must define constructer.' }

  sub _content { $_[0]->{either}->{content} }

  sub _is_available { Carp::croak 'you must define _is_available method.' }

  sub exists {
    my ($self, $code) = @_;
    Carp::croak 'few arguments($code)' if @_ < 2;
    my $content = $self->_content;
    local $_ = $content;
    $self->_is_available && $code->($content);
  }

  sub filter {
    my ($self, $code) = @_;
    my $result = $self->exists($code);
    $result ? option($self->{either}) : none;
  }

  sub flat_map { Carp::croak 'you must define flat_map method.' }

  sub foreach {
    my ($self, $code) = @_;
    my $content = $self->_content;
    if ( $self->_is_available ) {
      Carp::croak 'few arguments($code)' if @_ < 2;
      local $_ = $content;
      $code->($content);
    }
    ();
  }

  sub get {
    my $self = shift;
    my $content = $self->_content;
    $self->_is_available ? $content : Option::NoSuchElementException->throw;
  }

  sub get_or_else {
    my ($self, $default) = @_;
    Carp::croak 'few arguments($default)' if @_ < 2;
    my $content = $self->_content;
    $self->_is_available ? $content : $default;
  }

  sub map {
    my ($self, $code) = @_;
    my $content = $self->_content;
    if ( $self->_is_available ) {
      Carp::croak 'few arguments($code)' if @_ < 2;
      local $_ = $content;
      my $ret = $code->($content);
      Either::Right->new($ret);
    } else {
      $self;
    }
  }

  sub to_option {
    my $self = shift;
    $self->_is_available ? option($self->_content) : none;
  }

}

1;

