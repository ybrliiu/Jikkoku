package Jikkoku::Model::Unit {

  use Mouse;
  use Jikkoku;

  use constant {
    FILE_PATH         => 'log_file/unit_list.cgi',
    INFLATE_TO        => 'Jikkoku::Class::Unit',
    PRIMARY_ATTRIBUTE => 'member_id',
  };

  with 'Jikkoku::Model::Role::TextData::Integration';

  # 無所属
  sub neutral {
    my $class = shift;
    state $neutral = $class->INFLATE_TO->new({
      id                 => '__anonymous',
      name               => '無所属',
      country_id         => 114_514_1919,
      is_member_leader   => 0,
      member_id          => '__anonymous',
      member_name        => '__anonymous',
      member_icon        => 114_514_1919,
      base_town_id       => 0,
    });
  }

  __PACKAGE__->prepare;
  __PACKAGE__->meta->make_immutable;

}

1;

