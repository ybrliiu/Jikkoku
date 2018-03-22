use Test::Jikkoku;

use_ok 'Jikkoku::Model::HistoryLog';
ok(my $history_logger = Jikkoku::Model::HistoryLog->new);
is ref $history_logger->get_all, 'ARRAY';

done_testing;

