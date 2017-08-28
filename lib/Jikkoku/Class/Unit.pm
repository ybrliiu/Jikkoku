package Jikkoku::Class::Unit {

  use Mouse;
  use Jikkoku;

  with 'Jikkoku::Class::Role::TextData';

  has 'id'               => ( metaclass => 'Column', is => 'ro', isa => 'Str',  required => 1 );
  has 'name'             => ( metaclass => 'Column', is => 'rw', isa => 'Str',  required => 1 );
  has 'country_id'       => ( metaclass => 'Column', is => 'rw', isa => 'Int',  required => 1 );
  has 'is_member_leader' => ( metaclass => 'Column', is => 'rw', isa => 'Bool', required => 1 );
  has 'member_id'        => ( metaclass => 'Column', is => 'ro', isa => 'Str',  required => 1 );
  has 'member_name'      => ( metaclass => 'Column', is => 'rw', isa => 'Str',  required => 1 );
  has 'member_icon'      => ( metaclass => 'Column', is => 'rw', isa => 'Int',  required => 1 );
  has 'message'          => ( metaclass => 'Column', is => 'rw', isa => 'Str',  default  => '' );
  has 'can_join'         => ( metaclass => 'Column', is => 'rw', isa => 'Bool', default  => 0 );
  has 'base_town_id'     => ( metaclass => 'Column', is => 'rw', isa => 'Int',  required => 1 );
  has 'is_auto_gather_available' =>
    ( metaclass => 'Column', is => 'rw', isa => 'Bool', default => 0 );

  sub is_leader {
    my $self = shift;
    $self->is_member_leader;
  }

  __PACKAGE__->meta->make_immutable;

}

1;

