package Jikkoku::Model::Role::TextData::List::Integration {

  use Mouse::Role;
  use Jikkoku;

  with qw(
    Jikkoku::Model::Role::List
    Jikkoku::Model::Role::FileHandler::Integration::List
    Jikkoku::Model::Role::FileHandler::TextData::List
  );

}

1;

