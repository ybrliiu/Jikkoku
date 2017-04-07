use v5.14;
use warnings;
use Test::More;
use Test::Exception;

my $CLASS = 'Jikkoku::Class::State::Stuck';
use_ok $CLASS;
require Jikkoku::Model::Chara;
my $chara_model = Jikkoku::Model::Chara->new;
my $chara = $chara_model->get_with_option('ybrliiu')->get;
ok my $stuck = $CLASS->new(chara => $chara);
ok !$stuck->is_available;
ok $stuck->set_state_for_chara({
  giver_id => 'someone',
  available_time => time + 1,
});
ok $stuck->is_available;

done_testing;
