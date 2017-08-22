package Jikkoku::Class::State::SmallAgitation {

  use Mouse;
  use Jikkoku;

  has 'name'                => ( is => 'ro', isa => 'Str', default => '扇動【小】' );
  has 'defence_power'       => ( is => 'ro', isa => 'Int', default => 5 );
  has 'defence_power_ratio' => ( is => 'ro', isa => 'Num', default => 0.07 );

  with qw(
    Jikkoku::Class::State::State
    Jikkoku::Class::State::Role::Given
    Jikkoku::Class::State::Role::Expires
    Jikkoku::Class::State::Role::DecreaseDefencePower
  );

  __PACKAGE__->meta->make_immutable;

}

1;

