package Jikkoku::Class::State::SmallDivineProtection {

  use Mouse;
  use Jikkoku;

  has 'name'                         => ( is => 'ro', isa => 'Str', default => '加護【小】' );
  has 'increase_defence_power_ratio' => ( is => 'rw', isa => 'Num', default => 0.05 );

  with qw(
    Jikkoku::Class::State::State
    Jikkoku::Class::State::Role::Given
    Jikkoku::Class::State::Role::Expires
  );

  sub description {
    my $self = shift;
    '守備力が' . $self->increase_defence_power_ratio * 100 . '%上昇する。';
  }

  __PACKAGE__->meta->make_immutable;

}

1;

