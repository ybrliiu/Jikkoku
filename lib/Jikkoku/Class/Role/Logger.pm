package Jikkoku::Class::Role::Logger {

  use Mouse::Role;
  use Jikkoku;

  sub PRIMARY_ATTRIBUTE() { 'id' }

  has 'id' => ( is => 'ro', isa => 'Str', required => 1 );

  with qw(
    Jikkoku::Role::Logger
    Jikkoku::Class::Role::Division
  );

  sub hook_logger_build_args {
    my ($class, $id) = @_;
    (id => $id);
  }

}

1;

