##############################################################
#
# バトルマップ ルート検索                                    
#
##############################################################
#
# ダイクストラ法による(2016/12/14 作成)
#
# Node.pm --- ノードオブジェクト
# BattleMap.pm --- バトルマップオブジェクト基底ロール
# BattleMap/* --- Start, Middle, End 3種類のBMオブジェクト
#
##############################################################

use v5.24;
use warnings;
use feature qw/signatures/;
no warnings 'experimental::signatures';

use constant {
  SAVE_DIR => '../etc/battle_map_route/',
};

use lib './lib';
use Node;
use BattleMap::Start;
use BattleMap::Middle;
use BattleMap::End;
use TieSTDOUT;

use Carp qw/croak/;
use Clone qw/clone/;
use Path::Tiny;
use Data::Dumper;

my $iter = path('../etc/battle_map_data')->iterator;
my @route_list;
my $map_data = {};

while ( my $path = $iter->() ) {
  my $data = require $path;
  $map_data = {
    %$map_data,
    %$data,
  };
  (my $id = (split /\//, $path)[-1]) =~ s/.pl//;

  # 都市間マップと、都市IDを逆にした物の分だけルートを作成する
  if ($id =~ /-/) {
    push @route_list, $id;
    my ($right, $left) = split /-/, $id;
    push @route_list, "$left-$right";
  }
}

# calc_route();
print_nodes_distance();

sub calc_route {
  for my $route_id (@route_list) {

    say "route_id : $route_id";
    my ($start_map, $middle_map, $end_map) = get_use_map($route_id)->@*;

    my $handle = do {
     # $anon に標準出力に出力された文字列が貯まるようになる
     my $anon = tie local *STDOUT, 'TieSTDOUT';

      my $handle = do {
        my $anon = tie local *STDOUT, 'TieSTDOUT';
        $start_map->calc_shortest_route;
        $start_map->print_route( undef, $middle_map->id );
        $anon;
      };
      my $calced_castle = $start_map->get_castle_node;
      $start_map->calc_around_castle_route( $calced_castle ) if $calced_castle;
      say $handle->to_s;

      $middle_map->calc_shortest_route( $start_map->id );
      $middle_map->print_route( $start_map->id, $end_map->id );

      $end_map->calc_shortest_route( $middle_map->id );
      $end_map->print_route( $middle_map->id, undef );

      $anon;
    };
    say $handle->to_s;
    path( SAVE_DIR . $route_id . '.pl' )->spew( $handle->to_s );

  }
}

sub print_nodes_distance {
  for my $route_id (@route_list) {
    say "route_id : $route_id";
    my ($start_map, $middle_map, $end_map) = get_use_map($route_id)->@*;

    $start_map->calc_shortest_route;
    $start_map->print_nodes_distance;

    $middle_map->calc_shortest_route( $start_map->id );
    $middle_map->print_nodes_distance;

    $end_map->calc_shortest_route( $middle_map->id );
    $end_map->print_nodes_distance;
  }
}

sub map_data($type, $map_id) {
  my $map = $map_data->{$map_id};
  return unless defined $map;

  # そのまま $map を渡すと元々のMapデータを壊してしまう
  my $class_name = 'BattleMap::' . ucfirst $type;
  my $battle_map = $class_name->new( clone $map );
  $battle_map->set_nodes();
  $battle_map->set_edges_node();
  $battle_map;
}

sub get_use_map($route_id) {
  my @tmp        = split /-/, $route_id;
  my $reverse_id = "$tmp[1]-$tmp[0]";
  my $start_map  = map_data(start => $tmp[0]) // get_use_map_error( $tmp[0] );
  my $middle_map = map_data(middle => $route_id) // map_data(middle => $reverse_id) // get_use_map_error($reverse_id);
  my $end_map = map_data(end => $tmp[1]) // get_use_map_error( $tmp[1] );
  [ $start_map, $middle_map, $end_map ];
}

sub get_use_map_error($str) {
  croak "マップが存在しません(id: $str )";
}

