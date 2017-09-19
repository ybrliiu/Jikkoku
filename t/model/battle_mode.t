use Jikkoku;
use Test::More;
use Test::Exception;

use Jikkoku::Model::Chara;
use Jikkoku::Class::Chara::ExtChara;

use_ok 'Jikkoku::Model::BattleMode';

# 準備
my $chara_model = Jikkoku::Model::Chara->new;
my $chara = Jikkoku::Class::Chara::ExtChara->new(chara => $chara_model->get_with_option('ybrliiu')->get);

ok( my $model = Jikkoku::Model::BattleMode->new(chara => $chara) );
ok @{ $model->get_all_with_result->get_all };

done_testing;

