package Jikkoku::Model::Role::Single {

  use Mouse::Role;
  use Jikkoku;

  sub PRIMARY_ATTRIBUTE() {}

  with 'Jikkoku::Model::Role::Base';

  sub get {
    my $self = shift;
    $self->INFLATE_TO->new;
  }

  sub get_with_option { Carp::croak q{Can't call get_with_option} }

  sub get_all { Carp::croak q{Can't call get_all} }

  sub delete { Carp::croak q{Can't call delete} }

}

1;

