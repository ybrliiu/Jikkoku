use v5.14;
use warnings;
use Test::More;
use Test::Exception;

my $CLASS = 'Jikkoku::Model::Country';
use_ok $CLASS;

ok(my $model = $CLASS->new);

{
  my $country_id = 2;
  my $before_country_name = '梁山泊';
  my $change_country_name = 'Perl Mongers';

  ok( my $country = $model->get($country_id) );
  is $country->name, $before_country_name;
  $country->name( $change_country_name );

  is $country->name, $change_country_name;
  $country->name( $before_country_name );
  ok $model->save;

  ok $country->king;
  is $country->king_name, 'りーう＠管理人';
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
    is $country->is_chara_has_position( $country->king_id ), '君主';
    is $country->position_name_of_chara( $country->king ), '君主';
  };

  subtest 'color' => sub {
    ok 1;
    is $country->color, '#ff69b4';
    is $country->background_color, '#ffd0db';
    is $country->background_color_rgba, '255,105,180,';
  };

  subtest 'number_of_chara_participate_available' => sub {
    require Jikkoku::Model::Chara;
    my $chara_model = Jikkoku::Model::Chara->new;
    ok my $num = $country->number_of_chara_participate_available($chara_model, $model);
    is $num, 5;
    is @{ $country->members($chara_model) }, 4;
    ok $country->can_participate($chara_model, $model);
  };

}

done_testing;
