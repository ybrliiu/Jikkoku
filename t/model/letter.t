use Jikkoku;
use Test::More;
use Test::Exception;

my $CLASS = 'Jikkoku::Model::Letter';
use_ok $CLASS;

ok( my $model = $CLASS->new );
ok( my $letter_list = $model->get_country_letter(0, 10) );
is @$letter_list, 10;

subtest 'add_country_letter' => sub {
  use Jikkoku::Model::Chara;
  use Jikkoku::Model::Country;
  my $sender          = Jikkoku::Model::Chara->new->get('ybrliiu');
  my $receive_country = Jikkoku::Model::Country->new->get(0);
  my $message         = 'HELL WORLD!!';
  ok $model->add_country_letter({
    sender          => $sender,
    receive_country => $receive_country,
    message         => $message,
  });
  ok( my $letter = $model->get(1)->[0] );
  is $letter->{message}, $message;
};

done_testing;
