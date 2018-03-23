use Test::Jikkoku;

use aliased 'Jikkoku::Service::BattleCommand::Battle::BattleLoop';
use_ok BattleLoop;

my $container = Test::Jikkoku::Container->new;
my $b_chara = $container->get('test.battle_chara');
$b_chara->soldier->num(100);
my $b_target = $container->get('test.battle_enemy');
$b_target->soldier->num(100);
my $chara_power = $container->get('test.chara_power');
my $target_power = $container->get('test.enemy_power');

ok(
  my $battle_loop = BattleLoop->new({
    chara        => $b_chara,
    target       => $b_target,
    chara_power  => $chara_power,
    target_power => $target_power,
    is_siege     => 0,
    distance     => 1,
    end_turn     => 10,
  })
);

lives_ok { $battle_loop->start_loop };
diag explain $battle_loop->chara->battle_logger->get(12);

done_testing;

