use v5.14;
use warnings;
use Test::More;
use Test::Exception;
use Test::Name::FromLine;

my $CLASS = 'Jikkoku::Model::Chara';
use_ok $CLASS;

ok my $model = $CLASS->new;

my $chara_list = $CLASS->get_all;
diag $_->name for @$chara_list;

ok(my $chara_list_to_hash = $CLASS->to_hash($chara_list));
is ref $chara_list_to_hash, 'HASH';

{
  my $change_force = 200;
  my $change_morale = 100;
  my $chara_id = 'leon333';

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

  is $chara->soldier->name, '雑兵';
  is $chara->soldier->attack_power( $chara ), 0;
  ok $chara->soldier_battle_map(move_point_charge_time => 120);

  subtest 'states_data' => sub {
    is $chara->states_data->get_with_option('hoge')->get, 100;
    ok $chara->states_data->set(fuga => 200);
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
    my $you = $model->opt_get('meemee')->get;
    ok not $you->can_protect($chara);
  };

}

done_testing();
