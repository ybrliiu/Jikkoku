package Jikkoku::Model::Role::TextData::General::Integration {

  use Mouse::Role;
  use Jikkoku;

  with qw(
    Jikkoku::Model::Role::General
    Jikkoku::Model::Role::FileHandler::Integration
    Jikkoku::Model::Role::FileHandler::TextData::General
  );

}

1;

