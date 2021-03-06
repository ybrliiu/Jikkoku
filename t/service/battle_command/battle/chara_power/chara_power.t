use Test::Jikkoku;
use Jikkoku::Class::Chara::ExtChara;
use Jikkoku::Service::Chara::Soldier::Sortie;
use Jikkoku::Service::BattleCommand::Battle::Chara;

my $TEST_CLASS = 'Jikkoku::Service::BattleCommand::Battle::CharaPower::CharaPower';
use_ok $TEST_CLASS;

# prepare
my $container = Test::Jikkoku::Container->new;
my $chara  = Jikkoku::Service::BattleCommand::Battle::Chara->new(chara => $container->get('test.chara'));
eval {
  Jikkoku::Service::Chara::Soldier::Sortie->new(soldier => $chara->soldier)
                                          ->sortie_to_staying_towns_castle;
};
my $target = Jikkoku::Service::BattleCommand::Battle::Chara->new(chara => $container->get('test.enemy'));
eval {
  Jikkoku::Service::Chara::Soldier::Sortie->new(soldier => $target->soldier)
                                          ->sortie_to_staying_towns_castle;
};

ok(
  my $chara_power = $TEST_CLASS->new({
    chara    => $chara,
    target   => $target,
    is_siege => 0,
  })
);
ok $chara_power->orig_attack_power;
ok $chara_power->orig_attack_power;
ok $chara_power->orig_defence_power;
ok $chara_power->attack_power;
ok $chara_power->defence_power;
lives_ok { $chara_power->write_to_log };

diag explain @{ $chara->battle_logger->data };

done_testing;

