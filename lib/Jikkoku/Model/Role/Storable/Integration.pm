package Jikkoku::Model::Role::Storable::Integration {

  use Mouse::Role;
  use Jikkoku;

  with qw(
    Jikkoku::Model::Role::Storable::FileHandler
    Jikkoku::Model::Role::Integration
  );

}

1;

