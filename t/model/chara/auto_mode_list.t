use Jikkoku;
use Test::More;
use Test::Exception;

my $CLASS = "Jikkoku::Model::Chara::AutoModeList";
use_ok $CLASS;

ok my $model = $CLASS->new;
is scalar @{ $model->get_all }, 0;
ok $model->lock;
ok $model->add('auto_player_id');
$model->get_with_option('auto_player_id')->foreach( sub { is $_, 'auto_player_id' } );
ok $model->commit;
ok scalar @{ $model->get_all }, 1;
ok $model->lock;
ok $model->delete('auto_player_id');
ok $model->commit;
is scalar @{ $model->get_all }, 0;
ok $model->init;

done_testing;

