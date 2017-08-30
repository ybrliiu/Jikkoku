use Jikkoku;
use Test::More;
use Test::Exception;

my $CLASS = 'Jikkoku::Model::Chara::Profile';
use_ok $CLASS;

ok( my $model = $CLASS->new );
ok( my $profile = $model->get('ybrliiu') );
is $profile->get, '管理人です';

subtest 'create - delete' => sub {
  ok $model->create('test_user');
  ok(my $profile = $model->get('test_user'));
  ok $profile->edit('some message');
  ok $profile->save;
  is $profile->get, 'some message';
  ok $model->delete('test_user');
};

done_testing;
