package BattleMap::Start {

  use v5.24;
  use Mouse;
  use feature qw/signatures/;
  no warnings 'experimental::signatures';

  use Carp qw/cluck/;
  use List::Util qw/min/;

  with 'BattleMap';

  sub get_start_node($self, @) {
    $self->get_castle_node;
  }

  sub get_end_node($self, $exit_map_id) {
    $self->get_check_point_node($exit_map_id);
  }

  sub set_calc_around_castle_node($self) {
    $self->loop_map(sub ($node, @) {
      my $new_node = CalcAroundCastleNode->new(
        x       => $node->x,
        y       => $node->y,
        terrain => $node->terrain,
      );
      $self->map_data->[$node->y][$node->x] = $new_node;
    });
  }

  sub get_same_coordinate_node($self, $node) {
    cluck "undefined node" unless $node;
    $self->map_data->[ $node->y ][ $node->x ];
  }

  sub _trace_around_castle_route($self, $start_node, $end_node) {
    $self->calc_shortest_route_by_node($start_node, $end_node);
    $self->reverse_route($end_node);
    $self->trace_route($start_node);
    $start_node->next;
  }

  sub _init_for_calc_around_castle_route($self) {
    $self->set_calc_around_castle_node;
    $self->set_edges_node;
  }

  sub _calc_around_castle_route_body($self, $castle_back, $castle_next) {
    $self->calc_shortest_route_by_node($castle_back, $castle_next);
    my $start_node_next = $self->_trace_around_castle_route($castle_back, $castle_next);
  }

  sub calc_around_castle_route($self, $calced_castle) {
    my $calced_castle_next = $calced_castle->next;
    $self->_init_for_calc_around_castle_route;

    my $castle      = $self->get_castle_node;
    my $castle_next = $self->get_same_coordinate_node( $calced_castle_next );
    my $castle_back = $self->_get_castle_back_node($castle, $castle_next);
    return warn "castle_back が見つかりませんでした (bm-id : @{[ $self->id ]}"  unless $castle_back;

    my $start_next = $self->_calc_around_castle_route_body($castle_back, $castle_next);
    return warn '$start_next_node が見つかりませんでした' unless $start_next;

    $self->_calc_other_around_castle_route( $start_next, $castle_next, $castle_back );
  }

  sub _get_castle_back_node($self, $castle, $castle_next) {
    my ($gap_x, $gap_y) = ($castle_next->x - $castle->x, $castle_next->y - $castle->y);
    my $castle_back = $self->get_node(sub ($node, @) {
      ($node->x == $castle->x - $gap_x) && ($node->y == $castle->y - $gap_y);
    });
  }

  sub _calc_other_around_castle_route($self, $old_start_next, $old_castle_next, $old_castle_back) {
    $self->_init_for_calc_around_castle_route;

    # 以前の別のルートを計算するため、以前計算したルートの始点の次ルートを計算済みにして
    # そちらのルートを計算しないようにする
    my $start_next = $self->get_same_coordinate_node( $old_start_next );
    $start_next->is_calced(1);

    my $castle_next = $self->get_same_coordinate_node( $old_castle_next );
    my $castle_back = $self->get_same_coordinate_node( $old_castle_back );
    $self->_calc_around_castle_route_body( $castle_back, $castle_next );
  }

  __PACKAGE__->meta->make_immutable;
}

1;

