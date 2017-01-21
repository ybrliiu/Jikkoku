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
my $c_m = Jikkoku::Model::Chara->new;
my $chara = $c_m->get('ybrliiu');

my ($x, $y) = ($chara->soldier_battle_map('x'), $chara->soldier_battle_map('y'));
ok( my $move = $CLASS->new({chara => $chara}) );
my $params = +{
  town_model       => Jikkoku::Model::Town->new,
  chara_model      => $c_m,
  battle_map_model => Jikkoku::Model::BattleMap->new,
};

subtest 'move up' => sub {
  lives_ok { $move->action({ direction => 'up', %$params }) };
  is $chara->soldier_battle_map('x'), $x;
  is $chara->soldier_battle_map('y'), $y - 1;
};

subtest 'move down' => sub {
  lives_ok { $move->action({ direction => 'down', %$params }) };
  is $chara->soldier_battle_map('x'), $x;
  is $chara->soldier_battle_map('y'), $y;
};

subtest 'move left' => sub {
  lives_ok { $move->action({ direction => 'left', %$params }) };
  is $chara->soldier_battle_map('x'), $x - 1;
  is $chara->soldier_battle_map('y'), $y;
};

subtest 'move right' => sub {
  lives_ok { $move->action({ direction => 'right', %$params }) };
  is $chara->soldier_battle_map('x'), $x;
  is $chara->soldier_battle_map('y'), $y;
};

# $move->action の中で save を行う
# 消費した移動Pを補充, save
$chara->soldier_battle_map(move_point => 10);
$chara->save;

done_testing;

