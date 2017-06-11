package Jikkoku::Class::ExtensiveStateRecord {

  use Mouse;
  use Jikkoku;

  has 'giver_id'       => ( is => 'ro', isa => 'Str', required => 1 );
  has 'state_id'       => ( is => 'ro', isa => 'Str', required => 1 );
  has 'available_time' => ( is => 'ro', isa => 'Num', required => 1 );

  sub key {
    my $self = shift;
    $self->giver_id . '.' . $self->state_id;
  }

  sub is_available {
    my ($self, $time) = @_;
    Carp::croak 'few arguments($time)' if @_ < 2;
    $self->available_time >= $time;
  }

  __PACKAGE__->meta->make_immutable;

}

1;
  
