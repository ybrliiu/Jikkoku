package Jikkoku::Class::BattleMap::Node {

  use Jikkoku;
  use Class::Accessor::Lite new => 0;

  use Carp qw/croak/;
  use Scalar::Util qw/weaken/;
  
  use constant {
    TEMP_INF => 1000_0000,

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
    SLOW_TIMES   => 1.7,
    KINTOUN_COST => 3,
  };

  {
    my %attributes = (
      x       => undef,
      y       => undef,
      terrain => undef,

      allies             => [],
      enemies            => [],
      is_current         => 0,
      can_move_direction => undef,

      edges_node => [],
      is_calced  => 0,
      distance   => TEMP_INF,
      from       => undef,
      next       => undef,
    );

    Class::Accessor::Lite->mk_accessors( keys %attributes );

    sub new {
      my ($class, $args) = @_;
      # 上で宣言したArrayRefは全オブジェクトで共有されてしまうため
      $args->{$_} = [] for qw/allies enemies edges_node/;
      bless {%attributes, %$args}, $class;
    }
  }

  sub current {
    my $self = shift;
    $self->{is_current} = 1;
  }

  sub push_ally {
    my ($self, $chara) = @_;
    push @{ $self->{allies} }, $chara;
  }

  sub push_enemy {
    my ($self, $chara) = @_;
    push @{ $self->{enemies} }, $chara;
  }

  sub _edges_node_set {
    my ($self, $new) = @_;
    weaken $_ for @$new;
  }

  sub name {
    my $self = shift;
    state $terrain_name = {
      NOTHING      ,=> '',
      PLAIN        ,=> '平地',
      FOREST       ,=> '森',
      MOUNTAIN     ,=> '山',
      FORTRESS     ,=> '砦',
      RIVER        ,=> '川',
      POISON       ,=> '毒',
      ALPINE       ,=> '高山',
      BOG          ,=> '沼地',
      POND         ,=> '池',
      SEA          ,=> '海',
      WOODS        ,=> '林',
      ROCKY_FIELD  ,=> '岩場',
      DESERT       ,=> '砂漠',
      SNOWY_FIELD  ,=> '雪原',
      ICE_FIELD    ,=> '氷原',
      ENTRY        ,=> '関所(入)',
      EXIT         ,=> '関所(出)',
      CASTLE       ,=> '城',
      HOUSES_FIELD ,=> '住宅地',
      BARREN       ,=> '荒地',
      WEAPON_SHOP  ,=> '武器屋',
      WATER_CASTLE ,=> '水塞',
    };
    $terrain_name->{ $self->{terrain} };
  }

  sub origin_cost {
    my ($self, $chara) = @_;
    state $node_cost = {
      NOTHING      ,=> TEMP_INF,
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
    $node_cost->{ $self->{terrain} };
  }

  sub color {
    my $self = shift;
    state $terrain_color = {
      NOTHING      ,=> 'black',
      PLAIN        ,=> 'green',
      FOREST       ,=> 'darkgreen',
      MOUNTAIN     ,=> 'darkgoldenrod',
      FORTRESS     ,=> 'saddlebrown',
      RIVER        ,=> 'deepskyblue',
      POISON       ,=> 'purple',
      ALPINE       ,=> 'peru',
      BOG          ,=> 'dimgray',
      POND         ,=> '#66ccff',
      SEA          ,=> '#000099',
      WOODS        ,=> 'forestgreen',
      ROCKY_FIELD  ,=> 'Gray',
      DESERT       ,=> 'yellow',
      SNOWY_FIELD  ,=> 'White',
      ICE_FIELD    ,=> 'Aquamarine',
      ENTRY        ,=> 'indigo',
      EXIT         ,=> 'indigo',
      CASTLE       ,=> '#FF4444',
      HOUSES_FIELD ,=> 'lightcoral',
      BARREN       ,=> 'darkred',
      WEAPON_SHOP  ,=> '#FF8000',
      WATER_CASTLE ,=> '#008B8B',
    };
    $terrain_color->{ $self->{terrain} };
  }

  sub cost {
    my ($self, $chara) = @_;
    my $cost = $self->origin_cost($chara);

    # 筋斗雲
    if (0) {
      $cost = $cost > KINTOUN_COST ? KINTOUN_COST : $cost;
    }
    # 足止め
    require Jikkoku::Class::State::Stuck;
    my $stuck = Jikkoku::Class::State::Stuck->new({chara => $chara});
    if ( $stuck->is_in_the_state(time) ) {
      $cost = $stuck->move_cost($cost);
    }
    $cost;
  }

  sub is_castle { is_terrain_castle(@_) }

  sub is_check_point {
    my $self = shift;
    my $terrain = ref $self ? $self->{terrain} : shift;
    $terrain == EXIT || $terrain == ENTRY;
  }

  sub is_terrain_castle {
    my $self = shift;
    my $terrain = ref $self ? $self->{terrain} : shift;
    $terrain == CASTLE || $terrain == WATER_CASTLE;
  }

  sub is_water {
    my $self = shift;
    state $water_terrains = [WATER_CASTLE, RIVER, POND, SEA, BOG];
    my $terrain = ref $self ? $self->{terrain} : shift;
    grep { $_ == $terrain } @$water_terrains;
  }

  # 辺のコスト
  sub edges_node_cost {
    my ($self, $node) = @_;
    my ($target_node) = grep { $node eq $_ } @{ $self->{edges_node} };
    defined $target_node ? $target_node->cost : TEMP_INF;
  }

}

package Jikkoku::Class::BattleMap::Node::Castle {

  use Jikkoku;
  use Carp;
  use parent 'Jikkoku::Class::BattleMap::Node';
  use Role::Tiny::With;
  with 'Jikkoku::Class::BattleMap::Node::Role::Castle';

  # override
  sub new {
    my ($class, $args) = @_;
    my $self = $class->SUPER::new($args);
    Carp::croak "城地形ではありません" if $self->{terrain} != $self->CASTLE;
    $self;
  }

}

package Jikkoku::Class::BattleMap::Node::WaterCastle {

  use Jikkoku;
  use Carp;
  use parent 'Jikkoku::Class::BattleMap::Node';
  use Role::Tiny::With;
  with map { "Jikkoku::Class::BattleMap::Node::Role::$_" } qw/Castle Water/;

  # override
  sub new {
    my ($class, $args) = @_;
    my $self = $class->SUPER::new($args);
    Carp::croak "水塞ではありません" if $self->{terrain} != $self->WATER_CASTLE;
    $self;
  }

}

package Jikkoku::Class::BattleMap::Node::Water {

  use Jikkoku;
  use parent 'Jikkoku::Class::BattleMap::Node';
  use Role::Tiny::With;
  with 'Jikkoku::Class::BattleMap::Node::Role::Water';

}

package Jikkoku::Class::BattleMap::Node::CheckPoint {

  use Jikkoku;
  use Carp;
  use parent 'Jikkoku::Class::BattleMap::Node';
  use Class::Accessor::Lite new => 0;

  {
    my %attributes = (check_point => undef);
    Class::Accessor::Lite->mk_accessors( keys %attributes );

    # override
    sub new {
      my ($class, $args) = @_;
      my $self = $class->SUPER::new($args);
      Carp::croak "関所ではありません" unless $self->is_check_point;
      $self->{$_} = $attributes{$_} for keys %attributes;
      $self;
    }
  }

  # override
  sub name {
    my $self = shift;
    $self->SUPER::name . "<br>@{[ $self->{check_point}->target_town_name ]}";
  }

}

1;

