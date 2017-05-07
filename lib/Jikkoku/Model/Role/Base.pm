package Jikkoku::Model::Role::Base {

  use Mouse::Role;
  use Jikkoku;

  requires qw(
    INFLATE_TO
    PRIMARY_ATTRIBUTE
    get
    get_with_option
    get_all
    delete
  );

}

1;
