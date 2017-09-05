package Jikkoku::Model::Role::FileHandler::Division {

  use Mouse::Role;
  use Jikkoku;

  sub PRIMARY_ATTRIBUTE() { 'id' }

  has 'id' => ( is => 'ro', isa => 'Str', required => 1 );

  with qw(
    Jikkoku::Role::FileHandler::Division
    Jikkoku::Model::Role::FileHandler::FileHandler
  );

  around open_data => sub {
    my ($orig, $class, $primary_attr) = (@_);
    ( $class->$orig($primary_attr), $class->PRIMARY_ATTRIBUTE => $primary_attr );
  };

}

1;

