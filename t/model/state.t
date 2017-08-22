use Jikkoku;
use Test::More;
use Test::Exception;

my $CLASS = 'Jikkoku::Model::State';
use_ok $CLASS;
require Jikkoku::Model::Chara;
my $chara_model = Jikkoku::Model::Chara->new;
my $chara = $chara_model->get_with_option('ybrliiu')->get;
ok $CLASS->new(chara => $chara);
ok $chara->states;
ok my $state = $chara->states->get_state_with_option({id => 'SmallDivineProtection'})->get;
ok $state->DOES('Jikkoku::Class::State::State');

subtest 'adjust_move_cost' => sub {
  my $stuck = $chara->states->get('Stuck');

  $stuck->set_state_for_chara({
    giver_id => 'someone',
    available_time => time + 1,
  });
  is $chara->states->adjust_move_cost(5), 3.5;

  $stuck->set_state_for_chara({
    giver_id => 'someone',
    available_time => time - 1,
  });
  ok !$chara->states->adjust_move_cost(100);
};

subtest 'adjust_battle_action_success_ratio' => sub {
  my $confuse = $chara->states->get_state('Confuse');
  $confuse->set_state_for_chara({
    giver_id       => 'someone',
    available_time => time + 1,
  });
  is $chara->states->adjust_battle_action_success_ratio(1), -0.3;
  $confuse->set_state_for_chara({
    giver_id       => 'someone',
    available_time => time - 1,
  });
  ok !$chara->states->adjust_battle_action_success_ratio(1);
};

diag explain $chara->states->get_all_states;

done_testing;
