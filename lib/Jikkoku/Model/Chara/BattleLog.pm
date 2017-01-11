package Jikkoku::Model::Chara::BattleLog {

  use v5.14;
  use warnings;
  use parent 'Jikkoku::Model::Base::TextData::Log::Division';

  use constant {
    MAX           => 600,
    FILE_DIR_PATH => 'charalog/blog/',
  };

}

1;
