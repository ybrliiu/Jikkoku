use Jikkoku;
use Test::More;
use Test::Exception;

my $CLASS = 'Jikkoku::Model::Announce';
use_ok $CLASS;
ok my $model = $CLASS->new;
ok $model->add('てすと');
ok my $announce = $model->get(1)->[0];
is $announce->{message}, 'てすと';
ok exists $announce->{time};
is @{ $model->get_all }, 1;
ok $model->save;

ok my $model = $CLASS->new;
is @{ $model->get_all }, 1;
ok $model->init;
ok $model->save;

done_testing;
