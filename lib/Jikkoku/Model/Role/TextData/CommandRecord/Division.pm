package Jikkoku::Model::Role::TextData::CommandRecord::Division {

  use Mouse::Role;
  use Jikkoku;

  with qw(
    Jikkoku::Model::Role::CommandRecord
    Jikkoku::Model::Role::FileHandler::Division
    Jikkoku::Model::Role::FileHandler::TextData::List
  );

}

1;

