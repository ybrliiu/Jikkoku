use Jikkoku;
use Test::More;
use Test::Exception;

use_ok 'Jikkoku::Model::HistoryLog';
ok(my $history_logger = Jikkoku::Model::HistoryLog->new);
is ref $history_logger->get_all, 'ARRAY';

done_testing;

