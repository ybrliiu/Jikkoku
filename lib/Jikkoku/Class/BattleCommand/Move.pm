package Jikkoku::Class::BattleCommand::Move {

  use v5.14;
  use warnings;
  use Role::Tiny::With;
  use parent 'Jikkoku::Class::BattleCommand::Base';
  with 'Jikkoku::Class::Role::BattleAction';

  use Carp qw/croak/;
  use Jikkoku::Util qw/validate_values/;

  use Jikkoku::Model::Chara;
  use Jikkoku::Model::Town;
  use Jikkoku::Model::BattleMap;

  use constant {
    LEFT  => 2,
    RIGHT => 3,
    DOWN  => 4,
    UP    => 5,

    POISON_DIE_PC => 20,
  };

  sub ensure_can_action {
    my ($self, $direction) = @_;
    croak "引数が足りません" if @_ < 2;

    my $chara_model  = Jikkoku::Model::Chara->new;
    my $town_model   = Jikkoku::Model::Town->new;
    my $bm_id        = $self->{chara}->soldier_battle_map('battle_map_id');
    my $battle_map   = Jikkoku::Model::BattleMap->new->get( $bm_id );
    my $current_node = $battle_map->get_node_by_point(
      $self->{chara}->soldier_battle_map('x'), 
      $self->{chara}->soldier_battle_map('y'), 
    );
    my $next_node = do {
      if ( $direction == LEFT ) {
        $battle_map->get_left_node( $current_node );
      } elsif ( $direction == RIGHT ) {
        $battle_map->get_right_node( $current_node );
      } elsif ( $direction == DOWN ) {
        $battle_map->get_down_node( $current_node );
      } elsif ( $direction == UP ) {
        $battle_map->get_up_node( $current_node );
      } else {
        undef;
      }
    };
    die " その座標は存在しません \n" unless defined $next_node;

    die " 他国の城の上に移動することはできません \n"
      if $next_node->terrain == $next_node->CASTLE && $battle_map->id eq $self->{chara}->town_id;

    my $enemy = $chara_model->first(sub {
      my ($chara) = @_;
      $chara->is_soldier_same_position( $bm_id, $next_node->x, $next_node->y )
        && $chara->country_id != $self->{chara}->country_id;
    });
    die " そのマスには敵がいるので移動できません \n" if defined $enemy;

    $next_node;
  }

  sub action {
    my ($self, $next_node) = @_;

    eval {
      my $move_point = $self->{chara}->soldier_battle_map('move_point');
      $self->{chara}->soldier_battle_map( move_point => $move_point - $next_node->cost( $self->{chara} ) );
      $self->{chara}->occur_move_point_charge_time;
      $self->{chara}->move_to( $next_node );
      $self->_move_to_poison( $next_node );
    };

    if (my $e = $@) {
      $self->{chara}->abort;
      die " $@ \n";
    }

  }

  sub _move_to_poison {
    my ($self, $next_node) = @_;
    if ($next_node->terrain == $next_node->POISON) {
      my $minus = $self->{chara}->soldier_num / POISON_DIE_PC;
      $self->{chara}->soldier_num( $self->{chara}->soldier_num - $minus );
      $self->{chara}->save_battle_log(
        "【<font color=purple>地形効果</font>】" . 
        "地形：<font color=purple>毒</font>の効果により兵士が倒れました。兵士<font color=blue>-$minus</font>人"
      );
    }
  }

}

1;
