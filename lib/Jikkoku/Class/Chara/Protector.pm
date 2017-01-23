package Jikkoku::Class::Chara::Protector {

  use Jikkoku;
  use parent 'Jikkoku::Class::Base::TextData';

  use constant {
    PRIMARY_KEY => 'id',
    COLUMNS     => [qw/id time/],
  };

  __PACKAGE__->make_accessors( COLUMNS );

}

1;
