use Test::Jikkoku;

my $CLASS = 'Jikkoku::Class::BattleCommand::Move';
use_ok $CLASS;

ok( my $move = $CLASS->new );
is $move->name, '移動';

done_testing;

