package Jikkoku::Class::BattleCommand::Move {

  use Moo;
  use Jikkoku;

  use Carp qw( croak );
  use Jikkoku::Util qw( validate_values );

  has 'poison_die_pc' => (is => 'rw', default => 0.05);

  with qw(
    Jikkoku::Class::BattleCommand::BattleCommand
    Jikkoku::Class::Role::BattleAction
  );

  sub ensure_can_action {
    my ($self, $args) = @_;
    validate_values $args => [qw/direction chara_model town_model battle_map_model/];

    my $bm_id = $self->chara->soldier_battle_map('battle_map_id');
    my $bm    = $args->{battle_map_model}->get($bm_id);
    my $next_node  = $bm->can_move({
      chara       => $self->chara,
      direction   => $args->{direction},
      chara_model => $args->{chara_model},
      town_model  => $args->{town_model},
    });
  }

  sub action {
    my ($self, $next_node) = @_;

    eval {
      my $move_point = $self->chara->soldier_battle_map('move_point');
      $self->chara->soldier_battle_map( move_point => $move_point - $next_node->cost( $self->chara ) );
      $self->chara->move_to( $next_node );
      $self->_move_to_poison( $next_node );
    };

    if (my $e = $@) {
      $self->chara->abort;
      throw($e);
    } else {
      $self->chara->save;
    }

  }

  sub _move_to_poison {
    my ($self, $next_node) = @_;
    if ($next_node->terrain == $next_node->POISON) {
      my $minus = $self->chara->soldier_num * $self->poison_die_pc;
      $self->chara->soldier_num( $self->chara->soldier_num - $minus );
      $self->chara->save_battle_log(
        "【<font color=purple>地形効果</font>】" . 
        "地形：<font color=purple>毒</font>の効果により兵士が倒れました。兵士<font color=blue>-$minus</font>人"
      );
    }
  }

}

1;
