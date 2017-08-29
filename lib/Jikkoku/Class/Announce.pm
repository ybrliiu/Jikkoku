package Jikkoku::Class::Announce {

  use Mouse;
  use Jikkoku;
  use Jikkoku::Util qw( year_month_day );

  with 'Jikkoku::Class::Role::TextData';

  has 'message' => ( metaclass => 'Column', is => 'rw', isa => 'Str', required => 1 );
  has 'time'    => ( metaclass => 'Column', is => 'rw', isa => 'Str', default => sub { year_month_day } );

  __PACKAGE__->meta->make_immutable;

}

1;

