use Jikkoku;
use Test::More;
use Test::Exception;

use Jikkoku::Model::Chara;
use Jikkoku::Class::Chara::ExtChara;
use Jikkoku::Service::Chara::Soldier::Sortie;

my $TEST_CLASS = 'Jikkoku::Service::BattleCommand::Battle::CharaPower::CharaPower';
use_ok $TEST_CLASS;

# prepare
my $chara_model = Jikkoku::Model::Chara->new;
my $chara  = Jikkoku::Class::Chara::ExtChara->new(chara => $chara_model->get('ybrliiu'));
Jikkoku::Service::Chara::Soldier::Sortie->new(soldier => $chara->soldier)->sortie_to_staying_towns_castle;
my $target = Jikkoku::Class::Chara::ExtChara->new(chara => $chara_model->get('soukou'));
Jikkoku::Service::Chara::Soldier::Sortie->new(soldier => $target->soldier)->sortie_to_staying_towns_castle;

ok(my $chara_power = $TEST_CLASS->new(chara => $chara, target => $target));
ok $chara_power->orig_attack_power;
ok $chara_power->orig_defence_power;
ok $chara_power->attack_power;
ok $chara_power->defence_power;
lives_ok { $chara_power->write_to_log };

diag explain @{ $chara->battle_logger->data }[0 .. 2];

done_testing;

