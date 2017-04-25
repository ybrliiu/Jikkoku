use v5.14;
use warnings;
use Test::More;
use Test::Exception;
use Test::Name::FromLine;

my $CLASS = 'Jikkoku::Class::BattleCommand::Move';
use_ok $CLASS;

use Jikkoku::Model::Chara;
use Jikkoku::Model::Town;
use Jikkoku::Model::BattleMap;

# 設定ファイル通りの時間だといつでもテストできないので
my $game_config = Jikkoku::Model::Config->get->{game};
local $game_config->{update_start_hour} = 0;
local $game_config->{update_end_hour}   = 24;

my $battle_map_model = Jikkoku::Model::BattleMap->new;
my $c_m = Jikkoku::Model::Chara->new;
my $chara = $c_m->get('ybrliiu');

# 準備
$chara->soldier->sortie_to_staying_towns_castle($battle_map_model);
$chara->soldier_battle_map(move_point => 20);
$chara->save;

my ($x, $y) = ($chara->soldier_battle_map('x'), $chara->soldier_battle_map('y'));
ok( my $move = $CLASS->new({chara => $chara}) );
my $params = +{
  town_model       => Jikkoku::Model::Town->new,
  chara_model      => $c_m,
  battle_map_model => $battle_map_model,
};

subtest 'move up' => sub {
  $move->exec({ direction => 'up', %$params });
  is $chara->soldier_battle_map('x'), $x;
  is $chara->soldier_battle_map('y'), $y - 1;
};

subtest 'move down' => sub {
  lives_ok { $move->exec({ direction => 'down', %$params }) };
  is $chara->soldier_battle_map('x'), $x;
  is $chara->soldier_battle_map('y'), $y;
};

subtest 'move left' => sub {
  lives_ok { $move->exec({ direction => 'left', %$params }) };
  is $chara->soldier_battle_map('x'), $x - 1;
  is $chara->soldier_battle_map('y'), $y;
};

subtest 'move right' => sub {
  lives_ok { $move->exec({ direction => 'right', %$params }) };
  is $chara->soldier_battle_map('x'), $x;
  is $chara->soldier_battle_map('y'), $y;
};

done_testing;

