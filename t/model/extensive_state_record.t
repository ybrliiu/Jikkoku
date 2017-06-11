use Jikkoku;
use Test::More;
use Test::Exception;
use Test::Name::FromLine;

my $CLASS = 'Jikkoku::Model::ExtensiveStateRecord';
use_ok $CLASS;

ok (my $model = $CLASS->new);
ok $model->lock;
my $args = {
  giver_id         => 'ybrliiu',
  state_id         => 'Protect',
  available_time   => time,
};
ok $model->add($args);
ok $model->commit;
ok $model->get_with_option($args->{giver_id}, $args->{state_id})->get;
ok $model->lock;
ok $model->delete($args->{giver_id}, $args->{state_id});
ok $model->commit;
ok $model->get_with_option($args->{giver_id}, $args->{state_id})->isa('Option::None');

done_testing;

