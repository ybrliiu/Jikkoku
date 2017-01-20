use v5.14;
use warnings;
use Test::More;
use Test::Exception;
use Test::Name::FromLine;

use constant Node => 'Jikkoku::Class::BattleMap::Node';

my $CLASS = 'Jikkoku::Model::BattleMap';
use_ok $CLASS;
ok( my $model = $CLASS->new );
ok( my $battle_map = $model->get(10) );

my $node = $battle_map->get_node( sub {
  my ($node) = @_;
  $node->terrain eq Node->CASTLE;
});
is $node->terrain, Node->CASTLE;

ok( my $battle_map2 =  $model->get('0-10') );
is $battle_map2->name, '晋陽-幽州間';
ok( $battle_map = $model->get(10) );
is $battle_map->name, '幽州の城付近';
for my $check_point (values %{ $battle_map->check_points }) {
  is ref $check_point, 'Jikkoku::Class::BattleMap::CheckPoint';
}

done_testing;
