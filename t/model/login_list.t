use Test::Jikkoku;

my $CLASS = 'Jikkoku::Model::LoginList';
use_ok $CLASS;

ok( my $model = $CLASS->new ); 
my $container = Test::Jikkoku::Container->new;
my $chara     = $container->get('test.chara');
ok $model->add($chara);

ok $model->update;
ok( my $login_list = $model->get_all );
is @$login_list, 1;
is $login_list->[0]->name, $chara->name;

ok( $login_list = $model->get_by_country_id( $chara->country_id ) );

done_testing;
