package Jikkoku::Model::GameDate {

  use Mouse;
  use Jikkoku;

  use constant INFLATE_TO => 'Jikkoku::Class::GameDate';

  with 'Jikkoku::Model::Role::Single';

  __PACKAGE__->prepare;

  __PACKAGE__->meta->make_immutable;

}

1;

