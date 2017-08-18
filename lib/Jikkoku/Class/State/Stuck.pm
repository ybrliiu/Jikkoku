package Jikkoku::Class::State::Stuck {

  use Mouse;
  use Jikkoku;

  use Carp qw( croak );
  use Jikkoku::Util qw( validate_values );

  has 'name'                          => ( is => 'ro', isa => 'Str', default => '足止め' );
  has 'increase_move_cost_ratio'      => ( is => 'rw', isa => 'Num', default => 0.7 );
  has 'increase_giver_contribute_num' => ( is => 'rw', isa => 'Num', default => 0.2 );
  has 'increase_giver_book_power_num' => ( is => 'rw', isa => 'Num', default => 0.003 );

  with qw(
    Jikkoku::Class::State::State
    Jikkoku::Class::State::Role::Given
    Jikkoku::Class::State::Role::Expires
    Jikkoku::Class::State::Role::MoveCostAdjuster
  );

  sub description {
    my $self = shift;
    '消費移動Pが元の消費移動Pの' . $self->increase_move_cost_ratio . '倍増加します。';
  }

  sub adjust_move_cost {
    my ($self, $origin_cost) = @_;
    Carp::croak 'few argments' if @_ < 2;
    $origin_cost * $self->increase_move_cost_ratio;
  }

  __PACKAGE__->meta->make_immutable;

}

1;

__END__

Role 

  State::MoveCostAdjuster -> take_bonus_for_giver
  State::SoldierStatusAdjuster -> take_bonus_for_giver

