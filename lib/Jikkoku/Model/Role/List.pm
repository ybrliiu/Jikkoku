package Jikkoku::Model::Role::List {

  use Mouse::Role;
  use Jikkoku;

  # constants
  requires qw( MAX );

  sub PRIMARY_ATTRIBUTE() {}

  has 'data' => ( is => 'rw', isa => 'ArrayRef', required => 1 );

  with 'Jikkoku::Model::Role::Base';

  sub add {
    my ($self, $args) = @_;
    my $letter = $self->INFLATE_TO->new($args);
    unshift @{ $self->data }, $letter;
    $self;
  }

  sub get {
    my ($self, $limit) = @_;
    Carp::croak 'few arguments($limit)' if @_ < 2;
    [ @{ $self->data }[0 .. $limit - 1] ];
  }

  sub get_with_option { Carp::croak q{Can't call get_with_option} }

  sub get_all { $_[0]->data }

  sub delete {
    my ($self, $index) = @_;
    Carp::croak 'few arguments($index)' if @_ < 2;
    splice (@{ $self->data}, $index, 1);
  }

}

1;

