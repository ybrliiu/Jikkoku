package Jikkoku::Class::State::KeisuCount {

  use Mouse;
  use Jikkoku;

  has 'name' => ( is => 'ro', isa => 'Str', default => '計数攻撃' );

  with qw(
    Jikkoku::Class::State::State
    Jikkoku::Class::State::Role::Counter
  );

  sub description { '出撃中に計数攻撃が発動した回数です。' }

  __PACKAGE__->meta->make_immutable;

}

1;

