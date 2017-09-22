package Jikkoku::Class::Skill::AttackCastle::GreatAttackCastle {

  use Mouse;
  use Jikkoku;

  has 'name'          => ( is => 'ro', isa => 'Str', default => '攻城1【大】' );
  has 'increase_turn' => ( is => 'ro', isa => 'Int', default => 2 );

  with qw(
    Jikkoku::Class::Skill::Skill
    Jikkoku::Service::BattleCommand::Battle::TurnAdjuster
  );

  my $SOLDIER_NAME = '投石機';

  sub is_acquired {
    my $self = shift;
    $self->chara->soldier->name eq $SOLDIER_NAME;
  }

  sub acquire {}

  sub description_of_effect_body {
    my $self = shift;
    '攻城時ターン数+' . $self->increase_turn . '。';
  }

  sub description_of_acquire_body {
    my $self = shift;
    $SOLDIER_NAME . 'を雇っている時。';
  }

  sub adjust_battle_turn {
    my $self = shift;
    $self->increase_turn;
  }

  __PACKAGE__->meta->make_immutable;

}

1;

