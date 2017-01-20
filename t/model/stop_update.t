use v5.14;
use warnings;
use Test::More;
use Test::Exception;

my $CLASS = 'Jikkoku::Model::StopUpdate';
use_ok $CLASS;
ok $CLASS->count;
ok $CLASS->update_end_until;

done_testing;
