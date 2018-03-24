package Jikkoku::Model::GameRecord {

  use Mouse;
  use Jikkoku;

  use constant INFLATE_TO => 'Jikkoku::Class::GameRecord';

  with 'Jikkoku::Model::Role::Single';

  __PACKAGE__->prepare;
  __PACKAGE__->meta->make_immutable;

}

1;
