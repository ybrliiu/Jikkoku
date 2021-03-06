use Test::Jikkoku;

my $CLASS = 'Jikkoku::Model::Letter';
use_ok $CLASS;

ok( my $model = $CLASS->new );
ok( my $letter_list = $model->get_country_letter(0, 10) );
is @$letter_list, 10;

subtest 'add_country_letter' => sub {
  use Jikkoku::Model::Chara;
  use Jikkoku::Model::Country;
  my $container = Test::Jikkoku::Container->new;
  my $sender    = $container->get('test.chara');
  my $country_model   = Jikkoku::Model::Country->new;
  my $receive_country = $country_model->get_with_option(0)->get_or_else( $country_model->neutral );
  my $message         = 'HELL WORLD!!';
  ok $model->add_country_letter({
    sender          => $sender,
    receive_country => $receive_country,
    message         => $message,
  });
  ok( my $letter = $model->get(1)->[0] );
  is $letter->message, $message;
};

done_testing;
