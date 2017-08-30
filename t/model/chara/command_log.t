use Jikkoku;
use Test::More;
use Test::Exception;

my $CLASS = 'Jikkoku::Model::Chara::CommandLog';
use_ok $CLASS;

ok( my $model = $CLASS->new );
ok( my $logger = $model->get('ybrliiu') );
ok( my $log = $logger->get(100) );
is @$log, 100;
ok $logger->add("[テストログ]");
ok $logger->save;

ok $logger = $model->get('ybrliiu');
ok ( $log = $logger->get(10) );
like $log->[0], qr/テストログ/;

subtest 'create - delete' => sub {
  ok $model->create('test_user');
  ok(my $logger = $model->get('test_user'));
  ok $model->delete('test_user');
};

done_testing;
