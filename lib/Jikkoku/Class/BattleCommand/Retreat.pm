package Jikkoku::Class::BattleCommand::Retreat {

  use Jikkoku;
  use Role::Tiny::With;
  use parent 'Jikkoku::Class::BattleCommand::Base';
  with 'Jikkoku::Class::Role::BattleAction::ActionTime';

  use Jikkoku::Model::Town;
  use Jikkoku::Model::BattleMap;

  sub ensure_can_action {
    my ($self) = @_;

    my $bm_id        = $self->{chara}->soldier_battle_map('battle_map_id');
    my $battle_map   = Jikkoku::Model::BattleMap->new->get( $bm_id );
    my $current_node = $battle_map->get_node_by_point(
      $self->{chara}->soldier_battle_map('x'), 
      $self->{chara}->soldier_battle_map('y'), 
    );

    throw("退却できる地形の上にいません")
      if $current_node->terrain != $current_node->ENTRY && $current_node->terrain != $current_node->CASTLE;

    $battle_map, $current_node;
  }

  sub _try_retreat {
    my ($self, $town) = @_;
    if ( $town->country_id == $self->{chara}->country_id ) {
      $self->{chara}->town_id( $town->id );
      $self->{chara}->soldier_retreat;
    } else {
      throw("他国の都市です。");
    }
    $town->name;
  }

  sub action {
    my ($self, $battle_map, $current_node) = @_;

    my $retreat_town_name = eval {

      my $town_model = Jikkoku::Model::Town->new;

      if ( $current_node->terrain == $current_node->ENTRY ) {
        my $check_point = $battle_map->get_check_point( $current_node );
        my $town        = $town_model->get( $check_point->target_bm_id );
        $self->_try_retreat( $town );
      }
      elsif ( $current_node->is_castle ) {
        my $town = $town_model->get( $self->{chara}->soldier_battle_map('battle_map_id') );
        $self->_try_retreat( $town );
      }
      else {
        throw("その地形の上では退却できません。");
      }

    };

    if (my $e = $@) {
      $self->{chara}->abort;
      throw($e);
    } else {
      my $log = "【退却】$retreat_town_name に退却しました。";
      $self->{chara}->save_battle_log($log);
      $self->{chara}->save_command_log($log);
    }

  }

}

1;

__END__

=encoding utf8

=head1 NAME
  
  Jikkoku::Class::BattleCommand::Retreat - 退却

=cut

