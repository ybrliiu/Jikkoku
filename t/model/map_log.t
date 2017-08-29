use Jikkoku;
use Test::More;
use Test::Exception;

my $CLASS = 'Jikkoku::Model::MapLog';
use_ok $CLASS;

my $str = "[テストログ] はろー、新世界。";
ok( my $model = $CLASS->new );
my $map_log = $model->get(11);
is @$map_log, 11;
ok $model->add($str);
ok $model->save;
ok( $map_log = $model->get(10) );
like($map_log->[0], qr/はろー/);

done_testing;

