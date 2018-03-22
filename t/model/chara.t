use Test::Jikkoku;

my $CLASS = 'Jikkoku::Model::Chara';
use_ok $CLASS;

ok my $model = $CLASS->new;

subtest anonymous => sub {
  ok my $dummy = $model->dummy;
  is $dummy->id, $model->INFLATE_TO->DUMMY_ID;
};

my $chara_list = $model->get_all;
diag $_->name for @$chara_list;

ok(my $chara_list_to_hash = $CLASS->to_hash($chara_list));
is ref $chara_list_to_hash, 'HASH';

subtest get_all_with_result => sub {
  ok my $chara = $model->get_with_option('haruka')->get;
  ok my $result = $model->get_all_with_result;
  my @allies = map {
    $_->name . "\n"
  } @{
    $result->get_charactors_by_country_id_with_result($chara->country_id)->get_all
  };
  is @allies, 6;
};

{
  my $change_force = 200;
  my $change_morale = 100;
  my $chara_id = 'haruka';

  ok(my $chara = $CLASS->get($chara_id));
  my $before_force = $chara->force;
  ok $chara->force( $change_force );

  lives_ok { $chara->morale_data('morale') };
  my $before_morale = $chara->morale_data('morale');
  dies_ok { $chara->morale_data('momo') };
  ok $chara->morale_data(morale => $change_morale);
  lives_ok { $chara->save };

  ok($chara = $CLASS->get($chara_id));
  is $chara->force, $change_force;
  $chara->force( $before_force );
  $chara->morale_data(morale => $before_morale);
  lives_ok { $chara->save };

  ok $chara->soldier_battle_map(move_point_charge_time => 120);

  subtest 'states_data' => sub {
    ok $chara->states_data->set(fuga => 200);
    is $chara->states_data->get_with_option('fuga')->get, 200;
  };

  subtest 'money' => sub {
    lives_ok { $chara->money };
    dies_ok { $chara->money(-100) };
    lives_ok { $chara->money(100) };
    is $chara->money, 100;
  };

  subtest 'move_point' => sub {
    lives_ok { $chara->soldier_battle_map(move_point => 20) };
    $chara->save;

    $chara->lock;
    dies_ok{ $chara->soldier_battle_map(move_point => -20) };
    ok $@;
    lives_ok { $chara->abort };
    is $chara->soldier_battle_map('move_point'), 20;
  };

  subtest 'can_protect' => sub {
    my $you = $model->get_with_option('yuuu')->get;
    ok $you->can_protect($chara);
  };

}

done_testing();
