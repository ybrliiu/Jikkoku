use Test::Jikkoku;

use_ok 'Jikkoku::Model::BattleMode';

my $container = Test::Jikkoku::Container->new;
my $chara = $container->get('test.ext_chara');
ok( my $model = Jikkoku::Model::BattleMode->new(chara => $chara) );
ok @{ $model->get_all_with_result->get_all };

done_testing;

