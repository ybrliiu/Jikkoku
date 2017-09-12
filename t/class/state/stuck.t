use Jikkoku;
use Test::More;
use Test::Exception;

use Jikkoku::Model::Chara;
use Jikkoku::Class::Chara::ExtChara;

my $CLASS = 'Jikkoku::Class::State::Stuck';
use_ok $CLASS;
my $chara_model = Jikkoku::Model::Chara->new;
my $chara = Jikkoku::Class::Chara::ExtChara->new(chara => $chara_model->get_with_option('ybrliiu')->get);
ok my $stuck = $CLASS->new(chara => $chara);
ok !$stuck->is_available;
ok $stuck->set_state_for_chara({
  giver_id => 'someone',
  available_time => time + 1,
});
ok $stuck->is_available;

done_testing;
