package BattleMap::Start {

  use v5.24;
  use Mouse;
  with 'BattleMap';

  sub get_start_node {
    my ($self) = @_;
    $self->get_castle_node;
  }

  sub get_end_node {
    my ($self, $exit_map_id) = @_;
    $self->get_check_point_node($exit_map_id);
  }

  __PACKAGE__->meta->make_immutable;
}

1;

