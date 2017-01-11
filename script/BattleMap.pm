package BattleMap {

  use v5.24;
  use Mouse::Role;
  use feature qw/signatures/;
  no warnings 'experimental::signatures';
  use Carp qw/croak/;
  use List::Util qw/min/;
  use Data::Dumper;

  has [qw/id name/]      => (is => 'ro', isa => 'Str', required => 1);
  has [qw/width height/] => (is => 'ro', isa => 'Int', required => 1);
  has 'map_data'         => (is => 'rw', isa => 'ArrayRef[ArrayRef]', required => 1);
  has 'check_points'     => (is => 'ro', isa => 'HashRef', required => 1);

  requires qw/get_start_node get_end_node/;

  # マップの空白地以外にNodeオブジェクトを入れていく
  sub set_nodes($self) {
    $self->loop_map(sub ($node, $y, $x) {
      # $node は まだNode Obj でない( terrain )
      my $new_node = Node->new(
        x       => $x,
        y       => $y,
        terrain => $node,
      );
      $self->map_data->[$y][$x] = $new_node;
    });
  }

  # 隣接ノードを登録
  sub set_edges_node($self) {
    $self->loop_map(sub ($node, @) {
      my %around_nodes = (
        up    => $self->get_up_node( $node ),
        down  => $self->get_down_node( $node ),
        right => $self->get_right_node( $node ),
        left  => $self->get_left_node( $node ),
      );
      $node->edges_node( [ map { $_ // () } values %around_nodes ] );
    });
  }

  sub loop_map($self, $code) {
    for my $i (0 .. $self->height - 1) {
      for my $j (0 .. $self->width - 1) {
        my $node = $self->map_data->[$i][$j];
        $code->($node, $i, $j) unless $node eq '';
      }
    }
  }

  sub get_node($self, $code) {
    for my $i (0 .. $self->height - 1) {
      for my $j (0 .. $self->width - 1) {
        my $node = $self->map_data->[$i][$j];
        unless ($node eq '') {
          my $ret = $code->($node);
          return $node if $ret;
        }
      }
    }
  }

  sub get_up_node($self, $node) {
    return undef if $node->y - 1 < 0;
    my $result_node = $self->{map_data}[ $node->y - 1 ][ $node->x ];
    return $result_node eq '' ? undef : $result_node;
  }
  
  sub get_down_node($self, $node) {
    return undef if $node->y + 1 >= $self->{height};
    my $result_node = $self->{map_data}[ $node->y + 1 ][ $node->x ];
    return $result_node eq '' ? undef : $result_node;
  }
  
  sub get_right_node($self, $node) {
    return undef if $node->x + 1 >= $self->{width};
    my $result_node = $self->{map_data}[ $node->y ][ $node->x + 1 ];
    return $result_node eq '' ? undef : $result_node;
  }
  
  sub get_left_node($self, $node) {
    return undef if $node->x - 1 < 0;
    my $result_node = $self->{map_data}[ $node->y ][ $node->x - 1 ];
    return $result_node eq '' ? undef : $result_node;
  }

  sub calc_shortest_route($self, $map_id = '') {
    my $start_node = $self->get_start_node($map_id);

    unless ($start_node) {
      warn " start_node を取得できませんでした。終了します。";
      return;
    }

    # 始点の初期化
    $start_node->distance(0);

    while (1) {
      my $vertex_node;

      # どの頂点を使って距離を求めるか調べる
      # まだ計算されていない頂点の中で、距離最小の点を探す
      $self->loop_map(sub ($node, @) {
        my $is_node_distance_shorter = !defined $vertex_node || $node->distance < $vertex_node->distance;
        if ( !$node->is_calced && $is_node_distance_shorter ) {
          $vertex_node = $node;
        }
      });

      # 全ての頂点で計算されていた場合, ループを抜ける
      last unless defined $vertex_node;

      $vertex_node->is_calced(1);

      # 各Node最短距離計算
      $self->loop_map(sub ($node, @) {
        my $min_distance = min( $node->distance, $vertex_node->distance + $vertex_node->edges_node_cost($node) );
        # $vertex_node からの距離の方が小さかった場合、 $vertex_node を記録 (後からルート作成する用)
        $node->from( $vertex_node ) if $min_distance != $node->distance;
        $node->distance( $min_distance );
      });
    }

  }

  sub get_castle_node($self) {
    my $node = $self->get_node(sub ($node) {
      $node->is_terrain_castle;
    });
  }

  sub get_check_point_node($self, $map_id) {
    my ($entry) = grep { $map_id eq $_->{target_bm_id} } values $self->check_points->%*;
    die "関所(出)が見つかりませんでした map_id: @{[ $self->id ]}, ($map_id)" unless defined $entry;
    my $node = $self->get_node(sub ($node) {
      $node->terrain eq Node->EXIT  &&
      $node->x       eq $entry->{x} &&
      $node->y       eq $entry->{y}
    });
  }

  sub print_nodes_distance($self) {
    say "<< MAP ID : @{[ $self->id ]} >>";
    for my $i (0 .. $self->height - 1) {
      print '[ ';
      for my $j (0 .. $self->width - 1) {
        my $node = $self->map_data->[$i][$j];
        if ($node ne '') {
          print $node->distance . ', ';
        } else {
          print q{'-', };
        }
      }
      say ' ],';
    }
  }

  sub call_from_node($from) {
    return unless $from;
    my $before = $from->from;
    return unless $before;
    $before->next( $from );
    call_from_node( $before );
  }

  sub call_next_node($self, $current) {
    return unless $current;
    my $next = $current->next;
    return unless $next;
    # say " x: @{[ $current->x ]}, y : @{[ $current->y ]}";
    say '$ROOT[' . $current->y . '][' . $current->x . ']->{"' . $self->id . '"} = "' . $next->y . ',' . $next->x . '";';
    $self->call_next_node( $next );
  }

  sub print_route_last_node($self, $end_node, $map_id) {
    return unless $end_node;
    say '$ROOT[' . $end_node->y . '][' . $end_node->x . ']->{"' . $self->id . '"} = "' . $map_id . '";';
  }

  sub print_route($self, $map_id = '') {
    my $end_node = $self->get_end_node($map_id);
    call_from_node($end_node);
    my $start_node = $self->get_start_node($map_id);
    $self->call_next_node($start_node);
    $self->print_route_last_node($end_node, $map_id);
  }

}

1;

