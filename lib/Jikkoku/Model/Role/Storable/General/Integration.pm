package Jikkoku::Model::Role::Storable::General::Integration {

  use Mouse::Role;
  use Jikkoku;

  with qw(
    Jikkoku::Model::Role::General
    Jikkoku::Model::Role::FileHandler::Integration
    Jikkoku::Model::Role::FileHandler::Storable::General
  );

}

1;

