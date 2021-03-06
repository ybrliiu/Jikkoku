use Test::Jikkoku;

use Jikkoku::Model::Config;
use Jikkoku::Model::BattleMap;

my $CLASS = 'Jikkoku::Service::BattleCommand::Exit';
use_ok $CLASS;

# 設定ファイル通りの時間だといつでもテストできないので
my $game_config = Jikkoku::Model::Config->get->{game};
local $game_config->{update_start_hour} = 0;
local $game_config->{update_end_hour}   = 24;

my $container = Test::Jikkoku::Container->new;
my $chara = $container->get('test.ext_chara');
my $battle_map_model = Jikkoku::Model::BattleMap->new;
my $chara_model = $container->get('model.chara');

subtest '成功ケース' => sub {

  my $soldier   = $chara->soldier;
  $soldier->retreat;
  my $bm        = $battle_map_model->get( $chara->town_id );
  my $exit_node = $bm->get_node(sub {
    my $node = shift;
    $node->terrain == $node->EXIT;
  });
  $soldier->sortie_to_around_staying_town({
    battle_map_model => $battle_map_model,
    x                => $exit_node->x,
    y                => $exit_node->y
  });
  $chara->save;

  my $exit = $CLASS->new({
    chara            => $chara,
    check_point_x    => $soldier->x,
    check_point_y    => $soldier->y,
    battle_map_model => $battle_map_model,
    chara_model      => $chara_model,
  });

  lives_ok { $exit->exec };
  is $soldier->battle_map_id, $exit_node->check_point->target_bm_id;

  $soldier->retreat;
  $chara->save;
};

done_testing;
