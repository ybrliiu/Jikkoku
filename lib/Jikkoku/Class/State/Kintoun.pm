package Jikkoku::Class::State::Kintoun {

  use Mouse;
  use Jikkoku;

  has 'name'                  => ( is => 'ro', isa => 'Str', default => '筋斗雲' );
  has 'overwriting_move_cost' => ( is => 'ro', isa => 'Num', default => 3.0 );

  with qw(
    Jikkoku::Class::State::State
    Jikkoku::Class::State::Role::Expires
  );

  sub description {
    my $self = shift;
    '消費移動ポイントが'
      . $self->over_write_move_cost
      . '以上の地形での消費移動ポイントが'
      . $self->over_write_move_cost
      . 'になります。';
  }

  sub overwrite_move_cost {
    my ($self, $orig_move_cost) = @_;
    $orig_move_cost > 3 ? $self->overwriting_move_cost : $orig_move_cost;
  }

  __PACKAGE__->meta->make_immutable;

}

1;

