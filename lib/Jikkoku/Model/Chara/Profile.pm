package Jikkoku::Model::Chara::Profile {

  use Jikkoku;
  use parent 'Jikkoku::Model::Base::TextData::Log::Division';

  use constant {
    MAX           => 1,
    FILE_DIR_PATH => 'charalog/prof/',
  };

  # override
  sub get {
    my ($self) = @_;
    $self->{data}[0];
  }

}

1;
