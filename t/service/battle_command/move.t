use Jikkoku;
use Test::More;
use Test::Exception;
use Test::Name::FromLine;

my $CLASS = 'Jikkoku::Service::BattleCommand::Move';
use_ok $CLASS;

use Jikkoku::Model::Chara;
use Jikkoku::Model::Town;
use Jikkoku::Model::BattleMap;
use Jikkoku::Class::Chara::ExtChara;

# 設定ファイル通りの時間だといつでもテストできないので
my $game_config = Jikkoku::Model::Config->get->{game};
local $game_config->{update_start_hour} = 0;
local $game_config->{update_end_hour}   = 24;

my $battle_map_model = Jikkoku::Model::BattleMap->new;
my $c_m = Jikkoku::Model::Chara->new;
my $chara   = Jikkoku::Class::Chara::ExtChara->new(chara => $c_m->get('ybrliiu'));
my $soldier = $chara->soldier;

# 準備
$soldier->sortie_to_staying_towns_castle($battle_map_model);
$soldier->move_point(20);
$chara->save;

my ($x, $y) = ($soldier->x, $soldier->y);
my $params = +{
  chara_model      => $c_m,
  battle_map_model => $battle_map_model,
};

subtest 'move up' => sub {
  my $move = $CLASS->new({
    chara     => $chara,
    direction => 'up',
    %$params,
  });
  lives_ok { $move->exec };
  is $chara->soldier->x, $x;
  is $chara->soldier->y, $y - 1;
};

subtest 'move down' => sub {
  my $move = $CLASS->new({
    chara     => $chara,
    direction => 'down',
    %$params,
  });
  lives_ok { $move->exec };
  is $chara->soldier->x, $x;
  is $chara->soldier->y, $y;
};

subtest 'move left' => sub {
  my $move = $CLASS->new({
    chara     => $chara,
    direction => 'left',
    %$params,
  });
  lives_ok { $move->exec };
  is $chara->soldier->x, $x - 1;
  is $chara->soldier->y, $y;
};

subtest 'move right' => sub {
  my $move = $CLASS->new({
    chara     => $chara,
    direction => 'right',
    %$params,
  });
  lives_ok { $move->exec };
  is $chara->soldier->x, $x;
  is $chara->soldier->y, $y;
};

$chara->soldier->retreat;
$chara->save;

done_testing;

