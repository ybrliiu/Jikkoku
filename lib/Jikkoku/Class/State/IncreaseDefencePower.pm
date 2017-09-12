package Jikkoku::Class::State::IncreaseDefencePower {

  use Mouse;
  use Jikkoku;

  has 'name' => ( is => 'ro', isa => 'Str', default => '守備力上昇' );

  with qw(
    Jikkoku::Class::State::State
    Jikkoku::Class::State::Role::Counter
    Jikkoku::Service::BattleCommand::Battle::CharaPower::DefencePowerAdjuster
  );

  sub description { '出撃中にスキル効果で上昇している守備力の値です。' }

  sub adjust_defence_power {
    my ($self, $orig_defence_power) = @_;
    $self->count;
  }

  __PACKAGE__->meta->make_immutable;

}

1;

