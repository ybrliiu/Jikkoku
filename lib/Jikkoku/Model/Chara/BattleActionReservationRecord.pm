package Jikkoku::Model::Chara::BattleActionReservationRecord {

  use Mouse;
  use Jikkoku;

  use constant {
    MAX        => 300,
    DIR_PATH   => 'charalog/auto_com/',
    INFLATE_TO => 'Jikkoku::Class::Chara::BattleActionReservation',
  };

  sub EMPTY_DATA() {
    my $class = shift;
    state $empty_data = $class->INFLATE_TO->new;
  }

  with 'Jikkoku::Model::Role::TextData::CommandRecord::Division';

  __PACKAGE__->prepare;

  __PACKAGE__->meta->make_immutable;

}

1;



