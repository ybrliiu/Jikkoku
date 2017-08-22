package Jikkoku::Class::State::GreatFeint {

  use Mouse;
  use Jikkoku;

  has 'name'               => ( is => 'ro', isa => 'Str', default => '陽動【大】' );
  has 'attack_power_ratio' => ( is => 'ro', isa => 'Num', default => 0.15 );

  with qw(
    Jikkoku::Class::State::State
    Jikkoku::Class::State::Role::Given
    Jikkoku::Class::State::Role::Expires
    Jikkoku::Class::State::Role::DecreaseAttackPower
  );

  __PACKAGE__->meta->make_immutable;

}

1;


