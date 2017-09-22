package Jikkoku::Class::Skill::Siege::SmallSiege {

  use Mouse;
  use Jikkoku;

  has 'name'          => ( is => 'ro', isa => 'Str', default => '攻城1【小】' );
  has 'increase_turn' => ( is => 'ro', isa => 'Int', default => 1 );

  with qw(
    Jikkoku::Class::Skill::Skill
    Jikkoku::Service::BattleCommand::Battle::TurnAdjuster
  );

  my @SOLDIER_NAME = qw( 衝車 雲梯 );

  sub is_acquired {
    my $self = shift;
    for my $soldier_name (@SOLDIER_NAME) {
      return 1 if $self->chara->soldier->name eq $soldier_name;
    }
    0;
  }

  sub acquire {}

  sub description_of_effect_body {
    my $self = shift;
    '攻城時ターン数+' . $self->increase_turn . '。';
  }

  sub description_of_acquire_body {
    my $self = shift;
    (join '、', @SOLDIER_NAME) . 'を雇っている時。';
  }

  sub adjust_battle_turn {
    my $self = shift;
    $self->increase_turn;
  }

  __PACKAGE__->meta->make_immutable;

}

1;

