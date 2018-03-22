use Test::Jikkoku;

my $CLASS = 'Jikkoku::Model::Config';
use_ok $CLASS;
my $config = $CLASS->get;
ok exists $config->{game};

done_testing;
