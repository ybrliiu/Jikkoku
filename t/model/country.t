use Test::Jikkoku;

my $CLASS = 'Jikkoku::Model::Country';
use_ok $CLASS;

ok(my $model = $CLASS->new);

{
  my $country_id = 2;
  my $before_country_name = '桜Trick';
  my $change_country_name = 'Perl Mongers';

  ok( my $country = $model->get($country_id) );
  is $country->name, $before_country_name;
  $country->name( $change_country_name );

  is $country->name, $change_country_name;
  $country->name( $before_country_name );
  ok $model->save;

  ok $country->king;
  is $country->king_name, '園田美月';
  ok $country->is_headquarters_exist;

  subtest 'commit and abort' => sub {
    my $change_name = 200_0000;
    ok $country->name( $change_name );
    lives_ok { $country->commit };
    lives_ok { $country->abort };
    is $country->name, $change_name;

    my $second_change_name = 100_0000;
    ok $country->name( $second_change_name );
    lives_ok { $country->abort };
    # commit していないので新しい値にならない
    is $change_name, $country->name;
  };

  subtest 'is_chara_has_position' => sub {
    ok $country->is_chara_has_position( $country->king_id );
    is $country->position_name_of_chara( $country->king ), '君主';
    my $position = $country->position_of_chara_with_option( $country->king )->get;
    is $position->id, 'king';
  };

  subtest 'color' => sub {
    ok 1;
    is $country->color, '#66cccc';
    is $country->background_color, '#ccffff';
    is $country->background_color_rgba, '102,204,204,'
  };

  subtest 'number_of_chara_participate_available' => sub {
    require Jikkoku::Model::Chara;
    my $chara_model = Jikkoku::Model::Chara->new;
    ok my $num = $country->number_of_chara_participate_available($chara_model, $model);
    is $num, 6;
    is @{ $country->members($chara_model) }, 3;
    ok $country->can_participate($chara_model, $model);
  };

}

done_testing;
