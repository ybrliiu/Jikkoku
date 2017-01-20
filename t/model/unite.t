use v5.14;
use warnings;
use Test::More;
use Test::Exception;

my $CLASS = 'Jikkoku::Model::Unite';
use_ok $CLASS;

lives_ok { $CLASS->is_unite };

ok $CLASS->unite;
is $CLASS->is_unite, 1;

ok $CLASS->separete;
is $CLASS->is_unite, 0;

done_testing();
