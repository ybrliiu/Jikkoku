use v5.14;
use warnings;
use Test::More;
use Test::Exception;
use Test::Name::FromLine;

my $CLASS = 'Jikkoku::Class::BattleCommand::Move';
use_ok $CLASS;

use Jikkoku::Model::Chara;
my $c_m = Jikkoku::Model::Chara->new;
my $chara = $c_m->get('ybrliiu');

my ($x, $y) = ($chara->soldier_battle_map('x'), $chara->soldier_battle_map('y'));
ok( my $move = $CLASS->new({chara => $chara}) );

subtest 'move up' => sub {
  lives_ok { $move->action('up') };
  is $chara->soldier_battle_map('x'), $x;
  is $chara->soldier_battle_map('y'), $y - 1;
};

subtest 'move down' => sub {
  lives_ok { $move->action('down') };
  is $chara->soldier_battle_map('x'), $x;
  is $chara->soldier_battle_map('y'), $y;
};

subtest 'move left' => sub {
  lives_ok { $move->action('left') };
  is $chara->soldier_battle_map('x'), $x - 1;
  is $chara->soldier_battle_map('y'), $y;
};

subtest 'move right' => sub {
  lives_ok { $move->action('right') };
  is $chara->soldier_battle_map('x'), $x;
  is $chara->soldier_battle_map('y'), $y;
};

done_testing;

