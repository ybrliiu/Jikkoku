package Jikkoku::Class::State::Confuse {

  use Mouse;
  use Jikkoku;

  use Carp qw( croak );
  use Jikkoku::Util qw( validate_values );

  has 'name'                                     => ( is => 'ro', isa => 'Str', default => '混乱' );
  has 'increase_giver_contribute_num'            => ( is => 'rw', isa => 'Num', default => 0.2 );
  has 'increase_giver_book_power_num'            => ( is => 'rw', isa => 'Num', default => 0.003 );
  has 'decrease_battle_action_success_ratio_num' => ( is => 'rw', isa => 'Num', default => -0.3 );

  with qw(
    Jikkoku::Class::State::State
    Jikkoku::Class::State::Role::Given
    Jikkoku::Class::State::Role::Expires
    Jikkoku::Class::State::Role::BattleActionSuccessRatioAdjuster
  );

  sub description {
    my $self = shift;
    'BM上で実行する全ての行動の成功率が' . $self->decrease_battle_action_success_ratio_num * -100 . '%減少します。';
  }

  sub adjust_battle_action_success_ratio {
    my ($self, $origin_success_ratio) = @_;
    Carp::croak 'few argments' if @_ < 2;
    $self->decrease_battle_action_success_ratio_num;
  }

  __PACKAGE__->meta->make_immutable;

}

1;

__END__

