package Jikkoku::Model::Role::FileHandler::Integration {

  use Mouse::Role;
  use Jikkoku;

  with qw(
    Jikkoku::Role::FileHandler::Integration
    Jikkoku::Model::Role::FileHandler::FileHandler
  );

}

1;

