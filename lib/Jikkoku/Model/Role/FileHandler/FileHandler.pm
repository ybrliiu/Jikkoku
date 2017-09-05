package Jikkoku::Model::Role::FileHandler::FileHandler {

  use Mouse::Role;
  use Jikkoku;

  with 'Jikkoku::Role::FileHandler';

  requires qw( open_data init );

  around BUILDARGS => sub {
    my ($orig, $class) = (shift, shift);
    if (ref $_[0] eq 'HASH' || @_ >= 2) {
      $class->$orig(@_);
    } else {
      $class->$orig( $class->open_data(@_) );
    }
  };

}

1;

