package Jikkoku::Model::Role::Base {

  use Mouse::Role;
  use Jikkoku;
  use Jikkoku::Util;
  use Module::Load;

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
    state $load_flag = {};
    if (!$load_flag->{$class}) {
      Module::Load::load($class->INFLATE_TO) unless Jikkoku::Util::is_module_loaded($class->INFLATE_TO);
      $load_flag->{$class} = 1;
    }
  }

}

1;
