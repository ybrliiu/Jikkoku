package Jikkoku::Class::GameRecord {

  use Mouse;
  use Jikkoku;
  use Jikkoku::Class::Role::TextData::Single;

  has 'period'         => ( is => 'rw', isa => 'Int', metaclass => 'Column', required => 1 );
  has 'is_test_period' => ( is => 'rw', isa => 'Bool', metaclass => 'Column', default => 0 );

  use constant FILE_PATH => 'log_file/game_record.txt';

  with 'Jikkoku::Class::Role::TextData::Single';

  sub formatted_period {
    my $self = shift;
    ($self->is_test_period ? 'テスト' : '第') . $self->period . '期';
  }

  __PACKAGE__->meta->make_immutable;

}

1;
