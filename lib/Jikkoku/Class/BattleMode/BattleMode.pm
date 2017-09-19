package Jikkoku::Class::BattleMode::BattleMode {

  use Mouse::Role;
  use Jikkoku;

  has 'chara' => ( is => 'ro', isa => 'Jikkoku::Class::Chara::ExtChara', required => 1 );

  # attributes
  requires qw( name consume_morale );

  sub use {
    my ($self, $battle_service) = @_;
    my $soldier = $self->chara->soldier;
    if ( $soldier->morale - $self->consume_morale < 0 ) {
      Jikkoku::Class::BattleMode::Exception->throw(
        '士気が足りないので' . $self->name . 'を使用できません' );
    }
    $soldier->morale( $soldier->morale - $self->consume_morale );
  }

  # methods
  requires qw( can_use );

}

package Jikkoku::Class::BattleMode::Exception {

  use parent 'Jikkoku::Exception';

}

1;

