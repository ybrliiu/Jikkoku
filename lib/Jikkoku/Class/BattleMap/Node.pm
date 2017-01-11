package Jikkoku::Class::BattleMap::Node {

  use Jikkoku;
  use Class::Accessor::Lite new => 0;

  use Carp qw/croak/;
  use Scalar::Util qw/weaken/;
  
  use constant {
    TEMP_INF => 100_0000,

    # 地形番号
    NOTHING      => 0,
    PLAIN        => 1,
    FOREST       => 2,
    MOUNTAIN     => 3,
    FORTRESS     => 4,
    RIVER        => 5,
    POISON       => 6,
    ALPINE       => 7,       # 高山
    BOG          => 8,       # 沼
    POND         => 9,
    SEA          => 10,
    WOODS        => 11,
    ROCKY_FIELD  => 12,
    DESERT       => 13,
    SNOWY_FIELD  => 14,
    ICE_FIELD    => 15,
    ENTRY        => 16,
    EXIT         => 17,
    CASTLE       => 18,      # 城
    HOUSES_FIELD => 19,      # 住宅地
    BARREN       => 20,      # 荒地
    WEAPON_SHOP  => 21,
    WATER_CASTLE => 22,      # 水塞

    
    # 定数
    WATER_NAVY_COST => 1,
    BOG_NAVY_COST   => 2,

    LAND_NAVY_TIMES => 5,
    SLOW_TIMES      => 1.7,

    KINTOUN_COST    => 3,
  };

  {
    my %attributes = (
      x       => undef,
      y       => undef,
      terrain => undef,

      exist_charactors => [],

      edges_node => [],
      is_calced  => 0,
      distance   => TEMP_INF,
      from       => undef,
      next       => undef,
    );

    Class::Accessor::Lite->mk_accessors( keys %attributes );

    sub new {
      my ($class, $args) = @_;
      bless {%attributes, %$args}, $class;
    }
  }

  sub set_exist_charactors {
    my ($self, $chara) = @_;
    push @{ $self->{exist_charactors} }, $chara;
  }

  sub _edges_node_set {
    my ($self, $new) = @_;
    weaken $_ for @$new;
  }

  sub cost {
    my ($self, $chara) = @_;

    state $node_cost = {
      NOTHING      ,=> 0,
      PLAIN        ,=> 2,
      FOREST       ,=> 3,
      MOUNTAIN     ,=> 4,
      FORTRESS     ,=> 6,
      RIVER        ,=> 5,
      POISON       ,=> 3,
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

    my $cost = do {
      if ( $chara->soldier->attr eq '水' ) {
        do {
          if (
            $self->{terrain} == WATER_CASTLE ||
            $self->{terrain} == RIVER        ||
            $self->{terrain} == POND         ||
            $self->{terrain} == SEA   
          ) {
            WATER_NAVY_COST;
          } elsif ( $self->{terrain} == BOG ) {
            BOG_NAVY_COST;
          } else {
            $node_cost->{$self->{terrain}} * LAND_NAVY_TIMES;
          }
        };
      }
      # 足止め
      elsif ( 0 ) {
        $node_cost->{$self->{terrain}} * SLOW_TIMES;
      }
      else {
        $node_cost->{$self->{terrain}};
      };
    };

    # 筋斗雲もらっている時
    if ( 0 ) {
      $cost = $cost > KINTOUN_COST ? KINTOUN_COST : $cost;
    }
    $cost;
  }

  sub is_terrain_castle {
    my $self = shift;
    $self->{terrain} == CASTLE || $self->{terrain} == WATER_CASTLE;
  }

  # 辺のコスト
  sub edges_node_cost {
    my ($self, $node) = @_;
    my ($target_node) = grep { $node eq $_ } @{ $self->{edges_node} };
    defined $target_node ? $target_node->cost : TEMP_INF;
  }

}

1;

