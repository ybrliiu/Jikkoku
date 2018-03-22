use Test::Jikkoku;

my $CLASS = 'Jikkoku::Model::StopUpdate';
use_ok $CLASS;
is $CLASS->count, 18;
is $CLASS->update_end_until, 0;

done_testing;
