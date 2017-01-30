package Jikkoku::Class::State::Stuck {

  use Mouse;
  use Jikkoku;

  use Carp qw( croak );
  use Jikkoku::Util qw( validate_values );

  has 'name'            => ( is => 'ro', default => '足止め' );
  has 'icon'            => ( is => 'ro', default => 'stuck.png' );
  has 'effect_multiple' => ( is => 'rw', default => 1.7 );
  has 'chara'           => ( is => 'ro', weak_ref => 1, required => 1 );

  sub is_in_the_state {
    my ($self, $time) = @_;
    croak "引数が足りません" if @_ < 2;
    $self->chara->debuff('stuck') > $time;
  }

  sub move_cost {
    my ($self, $origin_cost) = @_;
    $self->effect_multiple * $origin_cost;
  }

  __PACKAGE__->meta->make_immutable;

}

1;
