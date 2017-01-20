use v5.14;
use warnings;
use Test::More;
use Test::Exception;

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
  ok !$town2->can_move($tonkou);
  ok $town2->can_move($town1);
};

subtest 'defender_list' => sub {
  use Jikkoku::Model::Chara;
  use Jikkoku::Model::BattleMap;
  my $chara_model = Jikkoku::Model::Chara->new;
  my $chara = $chara_model->get('ybrliiu');
  my $battle_map = Jikkoku::Model::BattleMap->new->get( $chara->town_id );
  my $town = $model->get( $chara->town_id );
  ok( my $defender_list = $town->defender_list($battle_map, $chara_model) );
  diag explain $defender_list;
};

done_testing;
