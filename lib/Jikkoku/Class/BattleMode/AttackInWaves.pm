package Jikkoku::Class::BattleMode::AttackInWaves {

  use Mouse;
  use Jikkoku;

  has 'name'           => ( is => 'ro', isa => 'Str', default => '波状攻撃' );
  has 'consume_morale' => ( is => 'ro', isa => 'Int', default => 7 );

  with qw( Jikkoku::Class::BattleMode::BattleMode );

  sub can_use {
    my $self = shift;
    $self->skills->get({category => 'Invasion', id => 'AttackInWaves'})->is_acquired;
  }

  __PACKAGE__->meta->make_immutable;

}

1;

