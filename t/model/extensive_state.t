use Test::Jikkoku;

my $CLASS = 'Jikkoku::Model::ExtensiveState';
use_ok $CLASS;

my $container = Test::Jikkoku::Container->new;
my $chara = $container->get('test.ext_chara');
ok( my $model = $CLASS->new(chara => $chara) );
ok( my $state = $model->get('Protect') );
diag $state->after_override_battle_target_service_class_name;

done_testing;
