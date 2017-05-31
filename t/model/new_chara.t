use v5.14;
use warnings;
use Test::More;
use Test::Exception;

use Jikkoku::Model::Chara;
my $CLASS = 'Jikkoku::Model::Chara';

ok my $chara_model = $CLASS->new;
ok my $chara = $chara_model->get_with_option('ybrliiu')->get;

subtest get_all_with_result => sub {
  ok my $result = $chara_model->get_all_with_result;
  my @allies = map {
    $_->name . "\n"
  } @{
    $result->get_charactors_by_country_id_with_result($chara->country_id)->get_all
  };
  is @allies, 4;
};

done_testing;
