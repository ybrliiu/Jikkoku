package Jikkoku::Service::BattleCommand::Battle::Chara {

  use Mouse;
  use Jikkoku;

  extends 'Jikkoku::Class::Chara::ExtChara';

  has 'is_attack'           => ( is => 'ro', isa => 'Bool', default => 0 );
  has 'battle_mode_id'      => ( is => 'ro', isa => 'Str', default => 'Default' );
  has 'battle_mode'         => ( is => 'ro', does => 'Jikkoku::Class::BattleMode::BattleMode', builder => '_build_battle_mode' );
  has 'can_take_damage'     => ( is => 'rw', isa => 'Bool', default => 1 );
  has 'first_soldier_num'   => ( is => 'ro', isa => 'Int', builder => '_build_first_soldier_num' );
  has 'increase_contribute' => ( is => 'rw', isa => 'Num', default => 0 );

  sub _build_battle_mode {
    my $self = shift;
    my $battle_mode = $self->battle_modes->get($self->battle_mode_id);
    unless ( $battle_mode->can_use ) {
      Jikkoku::Exception->throw($battle_mode->name . 'は使用できません');
    }
    $battle_mode;
  }

  sub _build_first_soldier_num {
    my $self = shift;
    $self->soldier->num;
  }

  __PACKAGE__->meta->make_immutable;

}

1;

