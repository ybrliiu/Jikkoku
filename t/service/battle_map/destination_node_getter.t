use Jikkoku;
use Test::More;
use Test::Exception;

my $CLASS = 'Jikkoku::Service::BattleMap::DestinationNodeGetter';
use_ok $CLASS;

require Jikkoku::Model::Chara;
my $chara_model = Jikkoku::Model::Chara->new;
my $chara       = $chara_model->get_with_option('ybrliiu')->get;
my $charactors  = $chara_model->get_all_with_result;
require Jikkoku::Model::BattleMap;
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

