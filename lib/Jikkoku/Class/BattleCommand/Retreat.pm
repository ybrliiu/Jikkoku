package Jikkoku::Class::BattleCommand::_Retreat {

  use Mouse;

  has 'name' => ( is => 'ro', isa => 'Str', default => '退却' );

  __PACKAGE__->meta->make_immutable;

}

package Jikkoku::Class::BattleCommand::Retreat {

  use Mouse;
  use Jikkoku;
  use Jikkoku::Util 'validate_values';

  has 'town_model'   => ( is => 'rw', isa => 'Jikkoku::Model::Town' );
  has 'battle_map'   => ( is => 'rw', isa => 'Jikkoku::Class::BattleMap' );
  has 'current_node' => ( is => 'rw', isa => 'Jikkoku::Class::BattleMap::Node' );

  with qw(
    Jikkoku::Class::BattleCommand::BattleCommand
    Jikkoku::Class::Role::BattleAction
    Jikkoku::Class::Role::BattleAction::OccurActionTime
  );

  sub ensure_can_exec {
    my ($self, $args) = @_;
    validate_values $args => [qw/ battle_map_model town_model /];

    $self->town_model( $args->{town_model} );

    my $soldier = $self->chara->soldier;
    $self->battle_map( $args->{battle_map_model}->get( $soldier->battle_map_id ) );
    $self->current_node( $self->battle_map->get_node_by_point( $soldier->x, $soldier->y ) );
    unless ( $self->current_node->can_retreat ) {
      Jikkoku::Class::Role::BattleActionException->throw("退却できる地形の上にいません");
    }

  }

  sub _try_retreat {
    my ($self, $town) = @_;
    if ( $town->country_id == $self->chara->country_id ) {
      $self->chara->town_id( $town->id );
      $self->chara->soldier->retreat;
    } else {
      throw("他国の都市です。");
    }
    $town->name;
  }

  sub exec {
    my $self = shift;
    my ($chara, $current_node) = ($self->chara, $self->current_node);
    $chara->lock;

    my $retreat_town_name = eval {
      if ( $current_node->terrain == $current_node->ENTRY ) {
        my $check_point = $self->battle_map->get_check_point( $current_node );
        my $town        = $self->town_model->get( $check_point->target_bm_id );
        $self->_try_retreat( $town );
      }
      elsif ( $current_node->is_castle ) {
        my $town = $self->town_model->get( $self->chara->soldier_battle_map('battle_map_id') );
        $self->_try_retreat( $town );
      }
      else {
        Jikkoku::Class::Role::BattleActionException->throw("その地形の上では退却できません。");
      }
    };

    if (my $e = $@) {
      $chara->abort;
      if ( Exception::Tiny->caught($e) ) {
        $e->rethrow;
      } else {
        die $e;
      }
    } else {
      $chara->commit;
      my $log = "【退却】$retreat_town_name に退却しました。";
      $chara->save_battle_log($log);
      $chara->save_command_log($log);
    }

  }

}

1;

__END__

=encoding utf8

=head1 NAME
  
  Jikkoku::Class::BattleCommand::Retreat - 退却

=cut

