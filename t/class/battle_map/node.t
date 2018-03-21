use Test::Jikkoku;

my $CLASS = 'Jikkoku::Class::BattleMap::Node';
use_ok $CLASS;

ok my $node = $CLASS->new({x => 0, y => 0, terrain => 1});
dies_ok { my $castle = "${CLASS}::Castle"->new({x => 0, y => 0, terrain => $CLASS->PLAIN}) };
lives_ok { my $castle = "${CLASS}::Castle"->new({x => 0, y => 0, terrain => $CLASS->CASTLE}) };
dies_ok { my $water_castle = "${CLASS}::WaterCastle"->new({x => 0, y => 0, terrain => $CLASS->CASTLE}) };
lives_ok { my $water_castle = "${CLASS}::WaterCastle"->new({x => 0, y => 0, terrain => $CLASS->WATER_CASTLE}) };
dies_ok { my $water = "${CLASS}::Water"->new({x => 0, y => 0, terrain => $CLASS->PLAIN}) };
lives_ok { my $water = "${CLASS}::Water"->new({x => 0, y => 0, terrain => $CLASS->SEA}) };
dies_ok { my $check_point = "${CLASS}::CheckPoint"->new({x => 0, y => 0, terrain => $CLASS->POND}) };
lives_ok { my $check_point = "${CLASS}::CheckPoint"->new({x => 0, y => 0, terrain => $CLASS->ENTRY}) };
lives_ok { my $check_point = "${CLASS}::CheckPoint"->new({x => 0, y => 0, terrain => $CLASS->EXIT}) };

done_testing;
