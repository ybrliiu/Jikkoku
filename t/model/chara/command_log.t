use v5.14;
use warnings;
use Test::More;
use Test::Exception;

my $CLASS = 'Jikkoku::Model::Chara::CommandLog';
use_ok $CLASS;

ok( my $model = $CLASS->new('ybrliiu') );
ok( my $log = $model->get(100) );
is @$log, 100;
ok $model->add("[テストログ]");
ok $model->save;

ok $model->refetch;
ok ( $log = $model->get(10) );
like $log->[0], qr/テストログ/;

done_testing;
