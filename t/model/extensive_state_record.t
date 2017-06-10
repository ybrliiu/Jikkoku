use Jikkoku;
use Test::More;
use Test::Exception;
use Test::Name::FromLine;

my $CLASS = 'Jikkoku::Model::ExtensiveStateRecord';
use_ok $CLASS;

ok (my $model = $CLASS->new);
my $state = Jikkoku::Class::ExtensiveStateRecord->new(
  giver_id         => 'ybrliiu',
  state_id         => 'Protect',
  available_time   => time,
);
ok $model->lock;
ok $model->add($state);
ok $model->commit;
ok $model->get_with_option($state->giver_id, $state->state_id)->get;
ok $model->lock;
ok $model->delete($state->key);
ok $model->commit;
ok $model->get_with_option($state->giver_id, $state->state_id)->isa('Option::None');

done_testing;

