use v5.14;
use warnings;
use Test::More;
use Test::Exception;

use Jikkoku::Model::Chara;

my $CLASS = 'Jikkoku::Model::LoginList';
use_ok $CLASS;

ok( my $model = $CLASS->new ); 
my $chara_model = Jikkoku::Model::Chara->new;
my $chara = $chara_model->get('ybrliiu');
ok $model->add($chara);

ok $model->update;
ok( my $login_list = $model->get_all );
is @$login_list, 1;
is $login_list->[0]->name, $chara->name;

ok( $login_list = $model->get_by_country_id( $chara->country_id ) );

done_testing;
