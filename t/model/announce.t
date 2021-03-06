use Test::Jikkoku;

my $CLASS = 'Jikkoku::Model::Announce';
use_ok $CLASS;
ok my $model = $CLASS->new;
ok $model->add_by_message('てすと');
ok my $announce = $model->get(1)->[0];
is $announce->message, 'てすと';
ok $announce->time;
is @{ $model->get_all }, 1;
ok $model->save;
ok $model->init;

done_testing;

