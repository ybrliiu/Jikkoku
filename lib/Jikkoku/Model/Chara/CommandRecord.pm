package Jikkoku::Model::Chara::CommandRecord {

  use Mouse;
  use Jikkoku;

  use constant {
    MAX        => 18 * 7,
    DIR_PATH   => 'charalog/command/',
    INFLATE_TO => 'Jikkoku::Class::Chara::Command',
  };

  sub EMPTY_DATA() {
    my $class = shift;
    state $empty_data = $class->INFLATE_TO->new({
      id          => 0,
      description => '何もしない',
    });
  }

  with 'Jikkoku::Model::Role::TextData::CommandRecord::Division';

  __PACKAGE__->prepare;

  __PACKAGE__->meta->make_immutable;

}

1;

