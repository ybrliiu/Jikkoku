use Jikkoku;
use Test::More;
use Test::Exception;
use Test::Name::FromLine;

use Jikkoku::Model::Chara;
use Jikkoku::Class::Chara::ExtChara;

my $CLASS = 'Jikkoku::Model::ExtensiveState';
use_ok $CLASS;

my $chara_model = Jikkoku::Model::Chara->new;
my $_chara      = $chara_model->get_with_option('ybrliiu')->get;
my $chara       = Jikkoku::Class::Chara::ExtChara->new(chara => $_chara);
ok( my $model = $CLASS->new(chara => $chara) );
ok( my $state = $model->get('Protect') );
diag $state->after_override_battle_target_service_class_name;

done_testing;
