package Jikkoku::Class::State::SmallDivineProtection {

  use Mouse;
  use Jikkoku;

  has 'name'                => ( is => 'ro', isa => 'Str', default => '加護【小】' );
  has 'defence_power'       => ( is => 'ro', isa => 'Int', default => 5 );
  has 'defence_power_ratio' => ( is => 'ro', isa => 'Num', default => 0.07 );

  with qw(
    Jikkoku::Class::State::State
    Jikkoku::Class::State::Role::Given
    Jikkoku::Class::State::Role::Expires
    Jikkoku::Class::State::Role::IncreaseDefencePower
  );

  __PACKAGE__->meta->make_immutable;

}

1;

