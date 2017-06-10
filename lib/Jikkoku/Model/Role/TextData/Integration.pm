package Jikkoku::Model::Role::TextData::Integration {

  use Mouse::Role;
  use Jikkoku;

  with qw(
    Jikkoku::Role::FileHandler::TextData
    Jikkoku::Model::Role::Integration
  );

}

1;
