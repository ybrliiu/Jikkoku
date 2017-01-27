use Jikkoku;
use Test::More;
use Test::Exception;

my $CLASS = "Jikkoku::Model::Chara::AutoModeList";
use_ok $CLASS;

ok my $model = $CLASS->new;
is scalar @{ $model->get_all }, 0;
ok $model->add('auto_player_id');
$model->opt_get('auto_player_id')->foreach( sub { is $_, 'auto_player_id' } );
ok $model->save;
ok $model->refetch;
ok scalar @{ $model->get_all }, 1;
ok $model->delete('auto_player_id');
ok $model->save;
ok $model->init;
is scalar @{ $model->get_all }, 0;

done_testing;

