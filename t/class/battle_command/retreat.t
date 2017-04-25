use v5.14;
use warnings;
use Test::More;
use Test::Exception;
use Test::Name::FromLine;

my $CLASS = 'Jikkoku::Class::BattleCommand::Retreat';
use_ok $CLASS;

# 設定ファイル通りの時間だといつでもテストできないので
my $game_config = Jikkoku::Model::Config->get->{game};
local $game_config->{update_start_hour} = 0;
local $game_config->{update_end_hour}   = 24;

use Jikkoku::Model::Chara;
my $c_m = Jikkoku::Model::Chara->new;

my $chara = $c_m->get('ybrliiu');

ok( my $retreat = $CLASS->new({chara => $chara}) );
require Jikkoku::Model::Town;
require Jikkoku::Model::BattleMap;
my $town_model       = Jikkoku::Model::Town->new;
my $battle_map_model = Jikkoku::Model::BattleMap->new;

subtest '城地形の上で自国都市に撤退' => sub {
  my $soldier = $chara->soldier;
  $soldier->retreat;
  $soldier->sortie_to_staying_towns_castle($battle_map_model);
  $chara->save;
  lives_ok {
    $retreat->exec({
      town_model       => $town_model,
      battle_map_model => $battle_map_model,
    });
  };
  ok !$soldier->is_sortie;
};

subtest '関所(入)の上で撤退' => sub {
  my $town = $town_model->get_by_name('上京');
  $chara->soldier->sortie_to_adjacent_town({
    adjacent_town_id => $town->id,
    battle_map_model => $battle_map_model,
  });
  $chara->save;

  lives_ok {
    $retreat->exec({
      town_model       => $town_model,
      battle_map_model => $battle_map_model,
    });
  };
  ok !$chara->soldier->is_sortie;
};

subtest '城地形の上で他国都市に撤退' => sub {
  my $before_town_id = $chara->town_id;
  $chara->town_id(0);
  $chara->soldier->sortie_to_staying_towns_castle($battle_map_model);
  $chara->save;

  dies_ok {
    $retreat->exec({
      town_model       => $town_model,
      battle_map_model => $battle_map_model,
    });
  };
  is $@->message, '他国の都市です。';
  ok $chara->soldier->is_sortie;

  $chara->town_id( $before_town_id );
  $chara->soldier->retreat;
  $chara->save;
};

subtest '退却できない地形から撤退' => sub {
  my $soldier = $chara->soldier;
  $soldier->sortie_to_staying_towns_castle($battle_map_model);
  $soldier->x( $soldier->x + 1 );
  $chara->save;
  dies_ok {
    $retreat->exec({
      town_model       => $town_model,
      battle_map_model => $battle_map_model,
    });
  };
  is $@->message, '退却できる地形の上にいません';
  ok $soldier->is_sortie;

  $soldier->retreat;
  $chara->save;
};

done_testing;
