use Jikkoku;
use Test::More;
use Test::Exception;
use Test::Name::FromLine;

use Jikkoku::Model::Chara;
use Jikkoku::Model::Town;
use Jikkoku::Model::BattleMap;
use Jikkoku::Class::Chara::ExtChara;

my $CLASS = 'Jikkoku::Service::BattleCommand::Retreat';
use_ok $CLASS;

# 設定ファイル通りの時間だといつでもテストできないので
my $game_config = Jikkoku::Model::Config->get->{game};
local $game_config->{update_start_hour} = 0;
local $game_config->{update_end_hour}   = 24;

my $c_m = Jikkoku::Model::Chara->new;
my $battle_map_model = Jikkoku::Model::BattleMap->new;
my $town_model = Jikkoku::Model::Town->new;

my $chara = Jikkoku::Class::Chara::ExtChara->new(chara => $c_m->get('ybrliiu'));

subtest '城地形の上で自国都市に撤退' => sub {
  ok( my $retreat = $CLASS->new({chara => $chara}) );
  $chara->town_id(1);
  my $soldier = $chara->soldier;
  $soldier->retreat;
  $soldier->sortie_to_staying_towns_castle($battle_map_model);
  $chara->save;
  lives_ok { $retreat->exec };
  ok !$soldier->is_sortie;
};

subtest '関所(入)の上で撤退' => sub {
  ok( my $retreat = $CLASS->new({chara => $chara}) );
  my $town = $town_model->get_by_name('上京');
  $chara->soldier->sortie_to_adjacent_town({
    adjacent_town_id => $town->id,
    battle_map_model => $battle_map_model,
  });
  $chara->save;

  lives_ok { $retreat->exec };
  ok !$chara->soldier->is_sortie;
};

subtest '城地形の上で他国都市に撤退' => sub {
  ok( my $retreat = $CLASS->new({chara => $chara}) );
  my $before_town_id = $chara->town_id;
  $chara->town_id(0);
  $chara->soldier->sortie_to_staying_towns_castle($battle_map_model);
  $chara->save;

  dies_ok { $retreat->exec };
  is $@->message, '他国の都市です。';
  ok $chara->soldier->is_sortie;

  $chara->town_id( $before_town_id );
  $chara->soldier->retreat;
  $chara->save;
};

subtest '退却できない地形から撤退' => sub {
  ok( my $retreat = $CLASS->new({chara => $chara}) );
  my $soldier = $chara->soldier;
  $soldier->sortie_to_staying_towns_castle($battle_map_model);
  $soldier->x( $soldier->x + 1 );
  $chara->save;
  dies_ok { $retreat->exec };
  is $@->message, '退却できる地形の上にいません';
  ok $soldier->is_sortie;

  $soldier->retreat;
  $chara->save;
};

done_testing;
