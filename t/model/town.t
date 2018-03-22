use Test::Jikkoku;

my $CLASS = 'Jikkoku::Model::Town';
use_ok $CLASS;

ok(my $model = $CLASS->new);

{
  my $town_id = 17;
  my $before_town_farm;
  my $change_town_farm = 2000;

  ok( my $town = $model->get($town_id) );
  is $town->name, '泉州';
  $before_town_farm = $town->farm;
  $town->farm( $change_town_farm );
  ok $model->save;

  is $town->farm, $change_town_farm;
  $town->farm( $before_town_farm );
  ok $model->save;

  subtest 'commit and abort' => sub {
    my $change_farmer = 200_0000;
    ok $town->farmer( $change_farmer );
    lives_ok { $town->commit };
    lives_ok { $town->abort };
    is $town->farmer, $change_farmer;

    my $second_change_farmer = 100_0000;
    ok $town->farmer( $second_change_farmer );
    lives_ok { $town->abort };
    # commit していないので新しい値にならない
    is $change_farmer, $town->farmer;
  };

}

subtest 'distance' => sub {
  my $town1 = $model->get(1);
  my $town2 = $model->get(2);

  is $town1->distance($town2), 2;
  my $tonkou = $model->get_by_name('敦煌');

  is $town2->distance($tonkou), 3;
  ok not $town2->can_move($tonkou);
  ok $town2->can_move($town1);

  my $isyu   = $model->get(15);
  my $sensyu = $model->get(17);
  ok $isyu->can_move($sensyu);
  ok $sensyu->can_move($isyu);

  my $raisyu = $model->get(16);
  ok $isyu->can_move($raisyu);
  ok $raisyu->can_move($isyu);

  my $kousyu = $model->get(9);
  ok $raisyu->can_move($kousyu);
  ok $kousyu->can_move($raisyu);

  ok not $isyu->can_move($kousyu);
  ok not $sensyu->can_move($kousyu);
  ok not $raisyu->can_move($sensyu);

  ok not $isyu->can_move($town1);
};

subtest 'defender_list' => sub {
  use Jikkoku::Model::BattleMap;
  my $container = Test::Jikkoku::Container->new;
  my $chara_model = $container->get('model.chara');
  my $chara = $container->get('test.chara');
  my $battle_map = Jikkoku::Model::BattleMap->new->get( $chara->town_id );
  my $town = $model->get( $chara->town_id );
  ok( my $defender_list = $town->defender_list($battle_map, $chara_model) );
  diag explain $defender_list;
};

done_testing;
