package Jikkoku::Service::BattleCommand::Move {

  use Mouse;
  use Jikkoku;
  use Carp;

  has 'direction'        => ( is => 'ro', isa => 'Str', required => 1 );
  has 'poison_die_ratio' => ( is => 'rw', isa => 'Num', default => 0.05 );

  has 'destination_node' => (
    is      => 'ro',
    isa     => 'Jikkoku::Class::BattleMap::Node',
    lazy    => 1,
    builder => '_build_destination_node',
  );

  has 'chara_model' => (
    is      => 'ro',
    isa     => 'Jikkoku::Model::Chara',
    lazy    => 1,
    default => sub {
      my $self = shift;
      $self->model('Chara')->new;
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

  with qw( Jikkoku::Service::BattleCommand::BattleCommand );

  sub _build_destination_node {
    my $self = shift;
    my $bm_id     = $self->chara->soldier->battle_map_id;
    my $bm        = $self->battle_map_model->get($bm_id);
    my $getter    = $self->service('BattleMap::DestinationNodeGetter')->new({
      direction  => $self->direction,
      chara      => $self->chara,
      battle_map => $bm,
      charactors => $self->chara_model->get_all_with_result,
    });
    $getter->get;
  }

  sub ensure_can_exec {
    my $self = shift;
    # call _build_destination_node
    $self->destination_node;
  }

  sub exec {
    my $self = shift;
    my ($chara, $soldier) = ($self->chara, $self->chara->soldier);

    $chara->lock;

    eval {
      $soldier->move_point( $soldier->move_point - $self->destination_node->cost_when_move($chara) );
      $soldier->set_coordinate_by_point( $self->destination_node );
      $self->_move_to_poison;
    };

    if (my $e = $@) {
      $chara->abort;
      if ( Jikkoku::Exception->caught($e) ) {
        $e->rethrow;
      } else {
        die $e;
      }
    } else {
      $chara->commit;
    }

  }

  sub _move_to_poison {
    my $self = shift;
    my $soldier = $self->chara->soldier;
    if ( $self->destination_node->terrain == $self->destination_node->POISON ) {
      my $minus = int( $soldier->num * $self->poison_die_ratio );
      $soldier->num( $soldier->num - $minus );
      $self->chara->save_battle_log(
        "【<font color=purple>地形効果</font>】" . 
        "地形：<font color=purple>毒</font>の効果により兵士が倒れました。兵士<font color=blue>-$minus</font>人"
      );
    }
  }

  __PACKAGE__->meta->make_immutable;

}

1;
