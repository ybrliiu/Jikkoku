package Jikkoku::Class::BattleMap::Node {

  use Mouse;
  use Jikkoku;

  use Carp qw( croak );
  use Scalar::Util qw( weaken );
  
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
    KINTOUN_COST => 3,
  };

  has 'x'       => ( is => 'ro', required => 1 );
  has 'y'       => ( is => 'ro', required => 1 );
  has 'terrain' => ( is => 'ro', required => 1 );

  has 'allies'             => ( is => 'rw', default => sub { [] } );
  has 'enemies'            => ( is => 'rw', default => sub { [] } );
  has 'is_current'         => ( is => 'rw', default => 0 );
  has 'can_move_direction' => ( is => 'rw' );

  has 'edges_node' => ( is => 'rw', default => sub { [] } );
  has 'is_calced'  => ( is => 'rw', default => 0 );
  has 'distance'   => ( is => 'rw', default => TEMP_INF );
  has 'from'       => ( is => 'rw' );
  has 'next'       => ( is => 'rw' );

  sub BUILD {}

  sub current {
    my $self = shift;
    $self->is_current(1);
  }

  sub push_ally {
    my ($self, $chara) = @_;
    push @{ $self->allies }, $chara;
  }

  sub push_enemy {
    my ($self, $chara) = @_;
    push @{ $self->enemies }, $chara;
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
    $terrain_name->{ $self->terrain };
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
    $node_cost->{ $self->terrain };
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
    $terrain_color->{ $self->terrain };
  }

  sub cost {
    my ($self, $chara) = @_;
    my $cost = $self->origin_cost($chara);

    # 筋斗雲
    if (0) {
      $cost = $cost > KINTOUN_COST ? KINTOUN_COST : $cost;
    }
    # 足止め
    my $stuck = $chara->states->get('Stuck');
    if ( $stuck->is_in_the_state(time) ) {
      $cost = $stuck->move_cost($cost);
    }

    $cost;
  }

  sub is_castle { is_terrain_castle(@_) }

  sub is_check_point {
    my $self = shift;
    my $terrain = ref $self ? $self->terrain : shift;
    $terrain == EXIT || $terrain == ENTRY;
  }

  sub is_terrain_castle {
    my $self = shift;
    my $terrain = ref $self ? $self->terrain : shift;
    $terrain == CASTLE || $terrain == WATER_CASTLE;
  }

  sub is_water {
    my $self = shift;
    state $water_terrains = [ WATER_CASTLE, RIVER, POND, SEA, BOG ];
    my $terrain = ref $self ? $self->terrain : shift;
    grep { $_ == $terrain } @$water_terrains;
  }

  # 辺のコスト
  sub edges_node_cost {
    my ($self, $node) = @_;
    my ($target_node) = grep { $node eq $_ } @{ $self->edges_node };
    defined $target_node ? $target_node->cost : TEMP_INF;
  }

}

package Jikkoku::Class::BattleMap::Node::Castle {

  use Mouse;
  use Carp;
  use Jikkoku;
  extends 'Jikkoku::Class::BattleMap::Node';
  with 'Jikkoku::Class::BattleMap::Node::Role::Castle';

  sub BUILD {
    my $self = shift;
    Carp::croak "城地形ではありません" if $self->terrain != $self->CASTLE;
  }

}

package Jikkoku::Class::BattleMap::Node::WaterCastle {

  use Mouse;
  use Carp;
  use Jikkoku;
  extends 'Jikkoku::Class::BattleMap::Node';
  with qw(
    Jikkoku::Class::BattleMap::Node::Role::Castle
    Jikkoku::Class::BattleMap::Node::Role::Water
  );

  sub BUILD {
    my $self = shift;
    Carp::croak( $self->name . 'ではありません' ) if $self->terrain != $self->WATER_CASTLE;
  }

}

package Jikkoku::Class::BattleMap::Node::Water {

  use Mouse;
  use Jikkoku;
  extends 'Jikkoku::Class::BattleMap::Node';
  with 'Jikkoku::Class::BattleMap::Node::Role::Water';

}

package Jikkoku::Class::BattleMap::Node::CheckPoint {

  use Mouse;
  use Carp;
  use Jikkoku;
  extends 'Jikkoku::Class::BattleMap::Node';

  has 'check_point' => ( is => 'rw' );

  sub BUILD {
    my $self = shift;
    Carp::croak "関所ではありません" unless $self->is_check_point;
  }

  around name => sub {
    my ($orig, $self) = @_;
    $self->$orig() . "<br>@{[ $self->check_point->target_town_name ]}";
  };

}

1;

