use Jikkoku;
use Test::More;
use Test::Exception;
use Test::Name::FromLine;

my $CLASS = 'Jikkoku::Class::BattleCommand::Entry';
use_ok $CLASS;

# 設定ファイル通りの時間だといつでもテストできないので
require Jikkoku::Model::Config;
my $game_config = Jikkoku::Model::Config->get->{game};
local $game_config->{update_start_hour} = 0;
local $game_config->{update_end_hour}   = 24;

require Jikkoku::Model::Chara;
my $chara_model = Jikkoku::Model::Chara->new;
my $chara       = $chara_model->get_with_option('ybrliiu')->get;
ok(my $entry = $CLASS->new(chara => $chara) );

require Jikkoku::Model::BattleMap;
require Jikkoku::Model::Town;
require Jikkoku::Model::Country;
require Jikkoku::Model::MapLog;
require Jikkoku::Model::Diplomacy;

my $battle_map_model = Jikkoku::Model::BattleMap->new;
my $town_model = Jikkoku::Model::Town->new;
my $country_model = Jikkoku::Model::Country->new;
my $map_log_model = Jikkoku::Model::MapLog->new;
my $diplomacy_model = Jikkoku::Model::Diplomacy->new;

subtest '成功ケース' => sub {
  my $soldier   = $chara->soldier;
  $soldier->retreat;
  my $town = $town_model->get_by_name('上京');
  $soldier->sortie_to_adjacent_town({
    battle_map_model => $battle_map_model,
    adjacent_town_id => $town->id,
  });
  $chara->save;

  lives_ok {
    $entry->exec({
      check_point_x    => $soldier->x,
      check_point_y    => $soldier->y,
      battle_map_model => $battle_map_model,
      town_model       => $town_model,
      chara_model      => $chara_model,
      country_model    => $country_model,
      map_log_model    => $map_log_model,
      diplomacy_model  => $diplomacy_model,
    });
  };

  $soldier->retreat;
  $chara->save;
};

done_testing;
