package Jikkoku::Class::Country::Position {

  use Mouse;
  use Jikkoku;

  has 'id'                     => ( is => 'ro', isa => 'Str',  required => 1 );
  has 'name'                   => ( is => 'ro', isa => 'Str',  required => 1 );
  has 'increase_attack_power'  => ( is => 'ro', isa => 'Int',  required => 1 );
  has 'increase_defence_power' => ( is => 'ro', isa => 'Int',  required => 1 );
  has 'is_headquarters'        => ( is => 'ro', isa => 'Bool', required => 1 );

  __PACKAGE__->meta->make_immutable;

}

1;

