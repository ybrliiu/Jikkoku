use v5.14;
use warnings;
use Test::More;
use Test::Exception;
use Test::Name::FromLine;

my $CLASS = 'Jikkoku::Class::BattleCommand::Exit';
use_ok $CLASS;

# 設定ファイル通りの時間だといつでもテストできないので
require Jikkoku::Model::Config;
my $game_config = Jikkoku::Model::Config->get->{game};
local $game_config->{update_start_hour} = 0;
local $game_config->{update_end_hour}   = 24;

require Jikkoku::Model::Chara;
my $chara_model = Jikkoku::Model::Chara->new;
my $chara       = $chara_model->get_with_option('ybrliiu')->get;
ok(my $exit = $CLASS->new(chara => $chara) );

require Jikkoku::Model::BattleMap;
require Jikkoku::Model::Town;
require Jikkoku::Model::Country;
require Jikkoku::Model::MapLog;

my $battle_map_model = Jikkoku::Model::BattleMap->new;
my $town_model = Jikkoku::Model::Town->new;
my $country_model = Jikkoku::Model::Country->new;
my $map_log_model = Jikkoku::Model::MapLog->new;

subtest '成功ケース' => sub {
  my $soldier   = $chara->soldier;
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

  lives_ok {
    $exit->action({
      check_point_x    => $soldier->x,
      check_point_y    => $soldier->y,
      battle_map_model => $battle_map_model,
      town_model       => $town_model,
      chara_model      => $chara_model,
      country_model    => $country_model,
      map_log_model    => $map_log_model,
    });
  };
  is $soldier->battle_map_id, $exit_node->check_point->target_bm_id;

  $soldier->retreat;
  $chara->save;
};

done_testing;
