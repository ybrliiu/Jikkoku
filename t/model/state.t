use Jikkoku;
use Test::More;
use Test::Exception;

use Jikkoku::Model::Chara;
use Jikkoku::Class::Chara::ExtChara;

use_ok 'Jikkoku::Model::State';

# 準備
my $chara_model = Jikkoku::Model::Chara->new;
my $chara = Jikkoku::Class::Chara::ExtChara->new(chara => $chara_model->get_with_option('ybrliiu')->get);

ok( my $state_model = Jikkoku::Model::State->new(chara => $chara) );

ok my $state = $state_model->get('SmallDivineProtection');
ok $state->DOES('Jikkoku::Class::State::State');

ok my $states = $state_model->get_all_with_result;
lives_ok { $states->get_all };

done_testing;

