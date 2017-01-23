package Jikkoku::Model::Chara::Command {

  use Jikkoku;
  use parent 'Jikkoku::Model::Base::TextData::Command';

  use constant {
    # 18 * 7 = 126
    MAX           => 126,
    COLUMNS       => [qw/id not_used description not_used2 options num/],
    EMPTY_DATA    => {
      id          => 0,
      description => '何もしない',
    },
    FILE_DIR_PATH => 'charalog/command/',
  };

}

1;
