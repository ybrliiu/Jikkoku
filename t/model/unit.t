use v5.14;
use warnings;
use Test::More;
use Test::Exception;

my $CLASS = 'Jikkoku::Model::Unit';
use_ok $CLASS;

ok(my $model = $CLASS->new);

{
  my $member_id = 'ybrliiu';

  ok( my $unit = $model->get($member_id) );
  $unit->join_permit(1);
  ok $model->save;

  ok $model->refetch;
  ok( $unit = $model->get($member_id) );
  is $unit->join_permit, 1;
  $unit->join_permit(0);
  ok $model->save;

}

done_testing;
