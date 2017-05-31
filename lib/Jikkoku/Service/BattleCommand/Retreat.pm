package Jikkoku::Service::BattleCommand::Retreat {

  use Mouse;
  use Jikkoku;

  has 'town_model' => (
    is      => 'ro',
    isa     => 'Jikkoku::Model::Town',
    lazy    => 1,
    default => sub {
      my $self = shift;
      $self->model('Town')->new;
    },
  );

  has 'battle_map_model' => (
    is      => 'ro',
    isa     => 'Jikkoku::Model::BattleMap',
    lazy    => 1,
    default => sub {
      my $self = shift;
      $self->model('BattleMap')->new;
    },
  );

  has 'battle_map' => (
    is      => 'ro',
    isa     => 'Jikkoku::Class::BattleMap',
    lazy    => 1,
    default => sub {
      my $self = shift;
      $self->battle_map_model->get( $self->chara_soldier->battle_map_id );
    },
  );

  has 'current_node' => (
    is      => 'ro',
    isa     => 'Jikkoku::Class::BattleMap::Node',
    lazy    => 1,
    default => sub {
      my $self    = shift;
      my $soldier = $self->chara_soldier;
      $self->battle_map->get_node_by_point( $soldier->x, $soldier->y );
    },
  );

  with qw(
    Jikkoku::Service::BattleCommand::BattleCommand
    Jikkoku::Service::Role::BattleAction
    Jikkoku::Service::Role::BattleAction::OccurActionTime
  );

  sub ensure_can_exec {
    my $self = shift;
    unless ( $self->current_node->can_retreat ) {
      Jikkoku::Service::Role::BattleActionException->throw("退却できる地形の上にいません");
    }
  }

  sub _try_retreat {
    my ($self, $town) = @_;
    if ( $town->country_id == $self->chara->country_id ) {
      $self->chara->town_id( $town->id );
      $self->chara->soldier->retreat;
    } else {
      Jikkoku::Service::Role::BattleActionException->throw("他国の都市です。");
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
        $self->battle_map->name;
        my $town = $self->town_model->get( $self->chara_soldier->battle_map_id );
        $self->_try_retreat( $town );
      }
      else {
        Jikkoku::Service::Role::BattleActionException->throw("その地形の上では退却できません。");
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

  __PACKAGE__->meta->make_immutable;

}

1;

__END__

=encoding utf8

=head1 NAME
  
  Jikkoku::Service::BattleCommand::Retreat - 退却

=cut

