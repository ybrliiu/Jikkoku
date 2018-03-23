use Test::Jikkoku;
use Jikkoku::Model::BattleMap;

my $CLASS = 'Jikkoku::Service::BattleMap::DestinationNodeGetter';
use_ok $CLASS;

my $container = Test::Jikkoku::Container->new;
my $chara = $container->get('test.ext_chara');
my $chara_model = $container->get('model.chara');
my $charactors  = $chara_model->get_all_with_result;
my $battle_map_model = Jikkoku::Model::BattleMap->new;
my $soldier = $chara->soldier;
$soldier->sortie_to_staying_towns_castle($battle_map_model);
my $battle_map  = $battle_map_model->get( $chara->soldier->battle_map_id );
ok my $service = $CLASS->new({
  chara => $chara,
  charactors => $charactors,
  battle_map => $battle_map,
  direction => 'up',
});
ok my $next_node = $service->get;

done_testing;

