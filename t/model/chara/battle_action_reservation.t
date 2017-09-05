use Jikkoku;
use Test::More;
use Test::Exception;

my $CLASS = 'Jikkoku::Model::Chara::BattleActionReservation';
use_ok $CLASS;

ok( my $model = $CLASS->new );
ok( my $list = $model->get('ybrliiu')->get(10) );
is @$list, 10;

my $test_id = 'test_player';
dies_ok { $model->get($test_id) };
ok $model->create($test_id);
ok (my $command_record = $model->get($test_id));
ok $model->delete($test_id);

done_testing;
