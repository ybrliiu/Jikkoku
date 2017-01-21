package Node {

  use v5.24;
  use Mouse;
  use feature qw/signatures/;
  no warnings 'experimental::signatures';

  use Carp qw/carp croak/;
  use Scalar::Util qw/weaken/;
  
  use constant {
    TEMP_INF => 1000000,

    NOTHING      => 0,
    PLAIN        => 1,
    FOREST       => 2,
    MOUNTAIN     => 3,
    FORTRESS     => 4,
    RIVER        => 5,
    POISON       => 6,
    ALPINE       => 7,     # 高山
    BOG          => 8,     # 沼
    POND         => 9,
    SEA          => 10,
    WOODS        => 11,
    ROCKY_FIELD  => 12,
    DESERT       => 13,
    SNOWY_FIELD  => 14,
    ICE_FIELD    => 15,
    ENTRY        => 16,
    EXIT         => 17,
    CASTLE       => 18,    # 城
    HOUSES_FIELD => 19,    # 住宅地
    BARREN       => 20,    # 荒地
    WEAPON_SHOP  => 21,
    WATER_CASTLE => 22,
  };

  has [qw/x y/]            => (is => 'ro', required => 1);
  # 地形
  has 'terrain'            => (is => 'rw', required => 1);
  # 隣接ノード
  has 'edges_node'         => (is => 'rw', isa => 'ArrayRef[Node]', trigger => \&_edges_node_set);
  has 'is_calced'          => (is => 'rw', default => 0);
  # 始点からの距離
  has 'distance'           => (is => 'rw', default => TEMP_INF);
  # どのノードから来たか
  has 'from'               => (is => 'rw', isa => 'Node', weak_ref => 1);
  has 'next'               => (is => 'rw', isa => 'Node', weak_ref => 1);

  sub _edges_node_set($self, $new, @) {
    weaken $_ for @$new;
  }

  sub cost($self) {
    state $cost = {
      NOTHING      ,=> 0,
      PLAIN        ,=> 2,
      FOREST       ,=> 3,
      MOUNTAIN     ,=> 4,
      FORTRESS     ,=> 6,
      RIVER        ,=> 5,
      POISON       ,=> 10, # 本来は 3 ここでは毒を避けさせるルートを取らせるため, 10に
      ALPINE       ,=> 6,
      BOG          ,=> 7,
      POND         ,=> 4,
      SEA          ,=> 5,
      WOODS        ,=> 2.5,
      ROCKY_FIELD  ,=> 4.5,
      DESERT       ,=> 3.5,
      SNOWY_FIELD  ,=> 3,
      ICE_FIELD    ,=> 1,
      ENTRY        ,=> 2,
      EXIT         ,=> 2,
      CASTLE       ,=> 2,
      HOUSES_FIELD ,=> 2.5,
      BARREN       ,=> 2,
      WEAPON_SHOP  ,=> 2,
      WATER_CASTLE ,=> 5,
    };
    $cost->{$self->terrain};
  }

  sub is_terrain_castle {
    my $self = shift;
    $self->terrain == CASTLE || $self->terrain == WATER_CASTLE;
  }

  # 辺のコスト
  sub edges_node_cost($self, $node) {
    my ($target_node) = grep { $node eq $_ } $self->edges_node->@*;
    defined $target_node ? $target_node->cost : TEMP_INF;
  }

  __PACKAGE__->meta->make_immutable;
}

1;

