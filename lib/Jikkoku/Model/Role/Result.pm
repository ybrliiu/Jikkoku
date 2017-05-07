package Jikkoku::Model::Role::Result {

  use Mouse::Role;
  use Jikkoku;

  has 'data' => ( is => 'ro', isa => 'ArrayRef', required => 1 );

  sub get_all {
    my $self = shift;
    $self->data;
  }

}

1;

