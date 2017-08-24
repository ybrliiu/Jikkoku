package Jikkoku::Model::Role::Base {

  use Mouse::Role;
  use Jikkoku;
  use Jikkoku::Util;
  use Module::Load ();

  requires qw(
    INFLATE_TO
    PRIMARY_ATTRIBUTE
    get
    get_with_option
    get_all
    delete
  );

  sub prepare {
    my $class = shift;
    Module::Load::load($class->INFLATE_TO) unless Jikkoku::Util::is_module_loaded($class->INFLATE_TO);
  }

}

1;
