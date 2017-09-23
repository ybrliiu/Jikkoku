package Jikkoku::Class::BattleMode::AttackInWaves {

  use Mouse;
  use Jikkoku;

  has 'name'            => ( is => 'ro', isa => 'Str', default => '波状攻撃' );
  has 'consume_morale'  => ( is => 'ro', isa => 'Int', default => 7 );
  has 'overwrite_ratio' => ( is => 'ro', isa => 'Num', default => 2 / 3 );

  with qw(
    Jikkoku::Class::BattleMode::BattleMode
    Jikkoku::Service::BattleCommand::Battle::OccurActionTimeOverwriter
  );

  sub can_use {
    my $self = shift;
    $self->skills->get({category => 'Invasion', id => 'AttackInWaves'})->is_acquired;
  }

  sub overwrite_battle_occur_action_time {
    my ($self, $orig_time) = @_;
    $orig_time * $self->overwrtie_ratio;
  }

  __PACKAGE__->meta->make_immutable;

}

1;

