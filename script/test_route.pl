# 自動移動ルートがちゃんとつながるかどうか

use v5.24;
use warnings;
use lib '../lib', '../', './lib';
use Path::Tiny;
use Test::More;
use List::Util qw/first/;

use Jikkoku::Model::BattleMap;


# bm自動移動ルート情報格納配列
our @ROOT;
# 自動移動ができない, テストを無視するマップMAP(実験場など)
my @IGNORE_BM_ID = qw/101 102 102-101 101-102/;
my $model = Jikkoku::Model::BattleMap->new;

my $dir = path('../etc/battle_map_route');
my $iter = $dir->iterator;
while ( my $path = $iter->() ) {

  require $path;
  my ($route_id) = ($path =~ m!([^/]+$)!);
  ($route_id) = ($route_id =~ /(.*)\.pl/);

  next if first { $route_id eq $_ } @IGNORE_BM_ID;

  my ($start_bm_id, $_end_bm_id) = split /-/, $route_id;
  my $start_bm = $model->get($start_bm_id);
  my $start_node = $start_bm->get_node(sub {
    my $node = shift;
    $node->is_castle;
  });
  my $middle_bm_id = trace_route($start_node->y, $start_node->x, $start_bm->id, 0);
  if ($middle_bm_id eq 'abort') {
    ok 0, "tarce start map : $route_id";
    next;
  } else {
    ok 1, "tarce start map : $route_id";
  }

  my ($start_next_y, $start_next_x) = split /,/, $ROOT[ $start_node->y ]->[ $start_node->x ]{ $start_bm->id };
  my $start_next_node  = $start_bm->get_node_by_coordinate($start_next_x, $start_next_y);
  my $castle_back_node = $start_bm->get_castle_back_node($start_node, $start_next_node);
  if ($castle_back_node) {
    my $middle_bm_id = trace_route($start_node->y, $start_node->x, $start_bm->id, 0);
    isnt $middle_bm_id, 'abort', "around castle trace : $route_id";
  }

  my $middle_bm = $model->get($middle_bm_id);
  my $entry_node = $middle_bm->get_node(sub {
    my $node = shift;
    if ($node->is_check_point) {
      $node->check_point->target_bm_id eq $start_bm->id;
    }
  });
  my $end_bm_id = trace_route($entry_node->y, $entry_node->x, $middle_bm->id, 0);

  my $end_bm = $model->get($end_bm_id);
  my $end_entry_node = $end_bm->get_node(sub {
    my $node = shift;
    if ($node->is_check_point) {
      $node->check_point->target_bm_id eq $middle_bm->id;
    }
  });
  my $end_sign = trace_route($end_entry_node->y, $end_entry_node->x, $end_bm->id, 0);
  is $end_sign, 'exit', "trace route : $route_id";

}

sub trace_route {
  my ($y, $x, $bm_id, $count) = @_;
  return "abort" if $count >= 80;

  my @data = split /,/, $ROOT[$y]->[$x]{$bm_id};
  if (@data == 1) {
    my $next_bm_id = $data[0];
    return $next_bm_id;
  }
  my ($next_y, $next_x) = @data;
  trace_route($next_y, $next_x, $bm_id, ++$count);
}

done_testing;

