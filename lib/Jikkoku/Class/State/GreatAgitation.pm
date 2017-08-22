package Jikkoku::Class::State::GreatAgitation {

  use Mouse;
  use Jikkoku;

  has 'name'                => ( is => 'ro', isa => 'Str', default => '扇動【大】' );
  has 'defence_power'       => ( is => 'ro', isa => 'Int', default => 10 );
  has 'defence_power_ratio' => ( is => 'ro', isa => 'Num', default => 0.15 );

  with qw(
    Jikkoku::Class::State::State
    Jikkoku::Class::State::Role::Given
    Jikkoku::Class::State::Role::Expires
    Jikkoku::Class::State::Role::DecreaseDefencePower
  );

  __PACKAGE__->meta->make_immutable;

}

1;

