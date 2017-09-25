package Jikkoku::Class::Skill::HasFormation::Huhen {

  use Mouse;
  use Jikkoku;

  has 'name'          => ( is => 'ro', isa => 'Str', default => '罘変陣' );
  has 'increase_turn' => ( is => 'ro', isa => 'Int', default => 1 );

  with qw(
    Jikkoku::Class::Skill::Skill
    Jikkoku::Class::Skill::Role::HasFormation
    Jikkoku::Service::BattleCommand::Battle::TurnAdjuster
  );

  sub is_acquired {
    my $self = shift;
    $self->chara->formation->name eq $self->name;
  }

  sub acquire {}

  sub description_of_effect_body {
    my $self = shift;
    '戦闘ターン数+' . $self->increase_turn . '。';
  }

  sub adjust_battle_turn {
    my $self = shift;
    $self->increase_turn;
  }

  __PACKAGE__->meta->make_immutable;

}

1;

