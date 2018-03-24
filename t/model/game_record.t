use Test::Jikkoku;

my $CLASS = 'Jikkoku::Model::GameRecord';
use_ok $CLASS;

my $model = $CLASS->new;
my $game_record = $model->get;
is $game_record->period, 16;
ok !$game_record->is_test_period;
is $game_record->formatted_period, '第16期';

subtest 'formatted period when test period' => sub {
  $game_record->is_test_period(1);
  is $game_record->formatted_period, 'テスト16期';
};

done_testing;
