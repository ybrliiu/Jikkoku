use Jikkoku;
use Test::More;
use Test::Exception;
use Test::Name::FromLine;

use Jikkoku::Model::Config;
use Jikkoku::Model::Chara;
use Jikkoku::Model::Town;
use Jikkoku::Model::BattleMap;

my $CLASS = 'Jikkoku::Service::BattleCommand::Entry';
use_ok $CLASS;

# 設定ファイル通りの時間だといつでもテストできないので
my $game_config = Jikkoku::Model::Config->get->{game};
local $game_config->{update_start_hour} = 0;
local $game_config->{update_end_hour}   = 24;

my $chara_model      = Jikkoku::Model::Chara->new;
my $chara            = $chara_model->get_with_option('ybrliiu')->get;
my $town_model       = Jikkoku::Model::Town->new;
my $battle_map_model = Jikkoku::Model::BattleMap->new;

subtest '成功ケース' => sub {

  my $soldier   = $chara->soldier;
  $soldier->retreat;
  my $town = $town_model->get_by_name('上京');
  $soldier->sortie_to_adjacent_town({
    battle_map_model => $battle_map_model,
    adjacent_town_id => $town->id,
  });
  $chara->save;

  my $entry = $CLASS->new({
    chara         => $chara,
    town_model    => $town_model,
    check_point_x => $soldier->x,
    check_point_y => $soldier->y,
  });

  lives_ok { $entry->exec };

  $soldier->retreat;
  $chara->save;
};

done_testing;
