package Either::Left {

  use v5.14;
  use warnings;
  use parent 'Either::Either';

  use Either::Right;

  sub new {
    my ($class, $content) = @_;
    Carp::croak 'Too few arguments (required: $content)' if @_ < 2;
    bless {content => $content}, $class;
  }

  sub fold {
    my ($self, $left_code, $right_code) = @_;
    Carp::croak 'Too few arguments (required: $left_code, $right_code)' if @_ < 3;
    local $_ = $self->{content};
    $left_code->($self->{content});
  }

  sub is_left() { 1 }

  sub is_right() { 0 }

  sub join_left {
    my $self = shift;
    $self->{content}->isa('Either::Either') ? $self->{content} : Carp::croak 'cant join_left';
  }

  sub join_right {
    my $self = shift;
    $self;
  }

  sub swap {
    my $self = shift;
    Either::Right->new($self->{content});
  }

  sub match {
    my ($self, %args) = @_;
    $self->SUPER::match(%args);
    local $_ = $self->{content};
    $args{Left}->( $self->{content} );
  }

}

1;

