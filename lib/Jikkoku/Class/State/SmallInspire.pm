package Jikkoku::Class::State::SmallInspire {

  use Mouse;
  use Jikkoku;

  has 'name'               => ( is => 'ro', isa => 'Str', default => '鼓舞【小】' );
  has 'attack_power_ratio' => ( is => 'ro', isa => 'Num', default => 0.07 );

  with qw(
    Jikkoku::Class::State::State
    Jikkoku::Class::State::Role::Given
    Jikkoku::Class::State::Role::Expires
    Jikkoku::Class::State::Role::IncreaseAttackPower
  );

  __PACKAGE__->meta->make_immutable;

}

1;

