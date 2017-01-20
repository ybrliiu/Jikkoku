use v5.14;
use warnings;
use Test::More;
use Test::Exception;

my $CLASS = 'Jikkoku::Model::Chara::Command';
use_ok $CLASS;

ok( my $model = $CLASS->new('ybrliiu') );
ok( my $list = $model->get(10) );
is @$list, 10;

my $test_id = 'hogehoge';
ok $CLASS->create($test_id);
ok( $model = $CLASS->new($test_id) );
is scalar @{ $model->get_all }, $model->MAX;
ok $model->remove;

done_testing;
