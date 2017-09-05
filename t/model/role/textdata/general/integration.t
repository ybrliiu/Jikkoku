use Jikkoku;
use Test::More;
use Test::Exception;

my $CLASS = 'Jikkoku::Model::Role::TextData::General::Integration';
use_ok $CLASS;

package Jikkoku::Model::Country {

  use Jikkoku;
  use Mouse;

  use constant {
    FILE_PATH         => 'log_file/country.cgi',
    INFLATE_TO        => 'Jikkoku::Class::Country',
    PRIMARY_ATTRIBUTE => 'id',
  };

  with 'Jikkoku::Model::Role::TextData::General::Integration';

  __PACKAGE__->prepare;

  __PACKAGE__->meta->make_immutable

}

my $country_model;
subtest new => sub {
  ok $country_model = Jikkoku::Model::Country->new;
};

subtest get => sub {
  dies_ok { $country_model->get };
  ok my $country = $country_model->get(1);
  is $country->name, '(本当は)平和主義共和国';
  dies_ok { $country_model->get(10) };
};

subtest get_with_option => sub {
  dies_ok { $country_model->get_with_option };
  ok my $none = $country_model->get_with_option(0);
  ok $none ->isa('Option::None');
  my $some = $country_model->get_with_option(1);
  ok $some->isa('Option::Some');
  ok my $country = $some->get;
  is $country->name, '(本当は)平和主義共和国';
};

subtest get_all => sub {
  ok my $countries = $country_model->get_all;
  is @$countries, 2;
};

subtest save => sub {
  my $country = $country_model->get(1);
  my $orig_name = $country->name;
  $country->name('ぽあ');
  $country_model->save;
  is $country->name, 'ぽあ';

  $country->name($orig_name);
  $country_model->save;
  is $country->name, $orig_name;
};

subtest 'lock -> commit | abort' => sub {
  ok $country_model->lock;
  $country_model->delete(1);
  dies_ok { $country_model->get(1) };
  ok $country_model->abort;
  ok $country_model->get(1);

  ok $country_model->lock;
  my $country = $country_model->get(2);
  ok $country_model->delete(2);
  dies_ok { $country_model->get(2) };
  ok $country_model->commit;
  dies_ok { $country_model->get(2) };

  $country_model->create($country);
  $country_model->save;
};

done_testing;
