use Jikkoku;
use Test::More;
use Test::Exception;

use Jikkoku::Model::Chara;
use Jikkoku::Class::Chara::ExtChara;

my $CLASS = 'Jikkoku::Service::BattleCommand::Battle::Chara';
use_ok $CLASS;

my $chara     = Jikkoku::Model::Chara->get('ybrliiu');
my $ext_chara = Jikkoku::Class::Chara::ExtChara->new(chara => $chara);
ok( my $battle_chara = $CLASS->new({ %$ext_chara, is_attack => 1 }) );
is $battle_chara->battle_mode->name, '通常';

done_testing;
