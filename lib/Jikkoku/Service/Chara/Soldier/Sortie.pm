package Jikkoku::Service::Chara::Soldier::Sortie {

  use Mouse;
  use Jikkoku;

  has 'soldier' => ( is => 'ro', isa => 'Jikkoku::Class::Chara::Soldier', required => 1 );

  has 'battle_map_model' => (
    is      => 'ro',
    isa     => 'Jikkoku::Model::BattleMap',
    lazy    => 1,
    default => sub {
      my $self = shift;
      $self->model('BattleMap')->new;
    },
  );
  
  with 'Jikkoku::Role::Loader';

  sub sortie_to_staying_towns_castle {
    my $self = shift;
    my $battle_map  = $self->battle_map_model->get_battle_map( $self->soldier->chara->town_id );
    my $castle_node = $battle_map->get_castle_node;
    $self->soldier->sortie($battle_map, $castle_node);
  }

  sub sortie_to_around_staying_town {
    my ($self, $x, $y) = @_;
    Carp::croak 'few arguments($x, $y)' if @_ < 3;
    my $battle_map = $self->battle_map_model->get_battle_map( $self->soldier->chara->town_id );
    my $stay_node  = $battle_map->get_node_by_coordinate($x, $y);
    Carp::confess 'そのマスにはいけません' unless $stay_node->can_stay;
    $self->soldier->sortie($battle_map, $stay_node);
  }

  sub sortie_to_adjacent_town {
    my ($self, $adjacent_town_id) = @_;
    Carp::croak 'few arguments($adjacent_town_id)' if @_ < 2;
    my $battle_map = $self->battle_map_model->get_between_town_battle_map({
      start_town_id  => $self->chara->town_id,
      target_town_id => $adjacent_town_id,
    });
    my $entry_node = $battle_map->get_node(sub {
      my $node = shift;
      if ($node->terrain == $node->ENTRY) {
        return $node->check_point->target_bm_id == $self->chara->town_id;
      }
    });
    $self->soldier->sortie($battle_map, $entry_node);
  }

}

1;

