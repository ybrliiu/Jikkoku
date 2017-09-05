package Jikkoku::Model::Role::TextData::General::Division {

  use Mouse::Role;
  use Jikkoku;

  with qw(
    Jikkoku::Model::Role::General
    Jikkoku::Model::Role::FileHandler::Division
    Jikkoku::Model::Role::FileHandler::TextData::General
  );

}

1;

