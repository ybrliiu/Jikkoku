use Jikkoku;
use Test::More;
use Test::Exception;
use Test::Name::FromLine;

use Jikkoku::Model::Chara;

my $CLASS = 'Jikkoku::Model::ExtensiveState';
use_ok $CLASS;

my $chara_model = Jikkoku::Model::Chara->new;
my $chara = $chara_model->get_with_option('ybrliiu')->get;
ok( my $model = $CLASS->new(chara => $chara) );
ok( my $state = $model->get('Protect') );

done_testing;
