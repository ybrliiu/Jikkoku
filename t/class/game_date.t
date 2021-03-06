use Test::Jikkoku;

use_ok 'Jikkoku::Class::GameDate';
ok(my $game_date = Jikkoku::Class::GameDate->new);

my $month = $game_date->month;
ok $game_date->month( $month + 1 );
ok $game_date->save;
is $game_date->month, $month + 1;

ok $game_date->month( $month );
ok $game_date->date;
is $game_date->map_bg_color, '#FFE0E0';
ok $game_date->save;

subtest 'init' => sub {
  ok $game_date->init("2017年1月11日19時");
  is $game_date->month, 0;
  is $game_date->elapsed_year, 0;
  is $game_date->time, 1484127600;
};

ok $game_date->month(1);

subtest 'set month' => sub {
  my ($origin_year, $origin_month) = ($game_date->year, $game_date->month);
  ok $game_date->month( $game_date->month + 37 );
  is $game_date->year, $origin_year + 3;
  is $game_date->month, $origin_month + 1;

  ok $game_date->month( $game_date->month - 37 );
  is $game_date->year, $origin_year;
  is $game_date->month, $origin_month;
};

subtest 'overload' => sub {
  my $origin_month = $game_date->month;
  ok $game_date++;
  is $game_date->month, $origin_month + 1;
  ok $game_date--;
  is $game_date->month, $origin_month;
  ok $game_date += 5;
  is $game_date->month, $origin_month + 5;
  ok $game_date -= 5;
  is $game_date->month, $origin_month;
};

done_testing;

