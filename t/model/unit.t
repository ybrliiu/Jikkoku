use Jikkoku;
use Test::More;
use Test::Exception;

my $CLASS = 'Jikkoku::Model::Unit';
use_ok $CLASS;

ok(my $model = $CLASS->new);

my $member_id = 'ybrliiu';

ok( my $unit = $model->get($member_id) );
$unit->can_join(1);
ok $model->save;

ok( $unit = $model->get($member_id) );
is $unit->can_join, 1;
$unit->can_join(0);
ok $model->save;

done_testing;
