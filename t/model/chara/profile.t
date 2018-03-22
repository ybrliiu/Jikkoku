use Test::Jikkoku;

my $CLASS = 'Jikkoku::Model::Chara::Profile';
use_ok $CLASS;

my $container = Test::Jikkoku::Container->new;
ok( my $model = $CLASS->new );
my $chara_id = $container->get('test.chara_id');
ok( my $profile = $model->get($chara_id) );
is $profile->get, "優ちゃん大好き\n";

subtest 'create - delete' => sub {
  ok $model->create('test_user');
  ok(my $profile = $model->get('test_user'));
  ok $profile->edit('some message');
  ok $profile->save;
  is $profile->get, 'some message';
  ok $model->delete('test_user');
};

done_testing;
