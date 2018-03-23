use Test::Jikkoku;

my $CLASS = 'Jikkoku::Service::BattleCommand::Battle::Chara';
use_ok $CLASS;

my $container = Test::Jikkoku::Container->new;
my $ext_chara = $container->get('test.ext_chara');
ok( my $battle_chara = $CLASS->new({ %$ext_chara, is_attack => 1 }) );
is $battle_chara->battle_mode->name, '通常';

done_testing;
