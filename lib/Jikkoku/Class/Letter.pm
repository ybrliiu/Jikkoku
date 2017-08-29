package Jikkoku::Class::Letter {

  use Mouse;
  use Jikkoku;
  use Jikkoku::Util qw( datetime );

  with 'Jikkoku::Class::Role::TextData';

  has 'letter_type'       => ( metaclass => 'Column', is => 'ro', isa => 'Str', required => 1 );
  has 'sender_id'         => ( metaclass => 'Column', is => 'ro', isa => 'Str', required => 1 );
  has 'sender_town_id'    => ( metaclass => 'Column', is => 'ro', isa => 'Str', required => 1 );
  has 'sender_name'       => ( metaclass => 'Column', is => 'ro', isa => 'Str', required => 1 );
  has 'message'           => ( metaclass => 'Column', is => 'ro', isa => 'Str', required => 1 );
  has 'receiver_name'     => ( metaclass => 'Column', is => 'ro', isa => 'Str', default => '' );
  has 'time'              => ( metaclass => 'Column', is => 'ro', isa => 'Str', default => sub { datetime } );
  has 'sender_icon'       => ( metaclass => 'Column', is => 'ro', isa => 'Int', required => 1 );
  has 'sender_country_id' => ( metaclass => 'Column', is => 'ro', isa => 'Int', required => 1 );
  has 'sender_unit_id'    => ( metaclass => 'Column', is => 'ro', isa => 'Str', default => '' );

  __PACKAGE__->meta->make_immutable;

}

1;
