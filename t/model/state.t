use Test::Jikkoku;

use_ok 'Jikkoku::Model::State';

my $container = Test::Jikkoku::Container->new;
my $chara     = $container->get('test.ext_chara');

ok( my $state_model = Jikkoku::Model::State->new(chara => $chara) );

ok my $state = $state_model->get('SmallDivineProtection');
ok $state->DOES('Jikkoku::Class::State::State');

ok my $states = $state_model->get_all_with_result;
lives_ok { $states->get_all };

done_testing;

