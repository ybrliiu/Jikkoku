package BattleMap::End {

  use v5.24;
  use Mouse;
  with 'BattleMap';
  use feature qw/signatures/;
  no warnings 'experimental::signatures';

  sub get_start_node($self, $start_map_id) {
    $self->get_check_point_node($start_map_id);
  }

  sub get_end_node($self, @) {
    $self->get_castle_node;
  }
  
  # override
  sub print_route_last_node($self, $end_node, @) {
    return unless $end_node;
    say '$ROOT[' . $end_node->y . '][' . $end_node->x . ']->{"' . $self->id . '"} = "exit";';
  }

  __PACKAGE__->meta->make_immutable;
}

1;

