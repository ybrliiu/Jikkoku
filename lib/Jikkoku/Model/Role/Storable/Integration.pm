package Jikkoku::Model::Role::Storable::Integration {

  use Mouse::Role;
  use Jikkoku;

  with qw(
    Jikkoku::Role::FileHandler::Storable
    Jikkoku::Model::Role::Integration
  );

}

1;

