package Jikkoku::Model::Soldier {

  use Mouse;
  use Jikkoku;

  use constant {
    INFLATE_TO       => 'Soldier',
    CONFIG_FILE_NAME => 'soldier',
  };

  with 'Jikkoku::Model::Role::ConfigToObject';

  __PACKAGE__->meta->make_immutable;

}

1;
