use Jikkoku;
use Test::More;
use Test::Exception;

use Jikkoku::Model::Chara;

my $CLASS = 'Jikkoku::Model::Skill';
use_ok $CLASS;

my $chara_model = Jikkoku::Model::Chara->new;
my $chara = $chara_model->get_with_option('ybrliiu')->get;
ok(my $model = $CLASS->new( chara => $chara ));
diag explain $model->get_all;

done_testing;

