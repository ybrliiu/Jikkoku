use Test::Jikkoku;

my $CLASS = 'Jikkoku::Model::Chara::Command';
use_ok $CLASS;

ok( my $model = $CLASS->new );
my $container = Test::Jikkoku::Container->new;
my $chara_id = $container->get('test.chara_id');
ok( my $list = $model->get($chara_id)->get(10) );
is @$list, 10;

my $test_id = 'test_player';
dies_ok { $model->get($test_id) };
ok $model->create($test_id);
ok (my $command_record = $model->get($test_id));
ok $model->delete($test_id);

done_testing;
