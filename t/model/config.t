use v5.14;
use warnings;
use Test::More;
use Test::Exception;
use Test::Name::FromLine;

my $CLASS = 'Jikkoku::Model::Config';
use_ok $CLASS;
my $config = $CLASS->get;
ok exists $config->{game};

done_testing;
