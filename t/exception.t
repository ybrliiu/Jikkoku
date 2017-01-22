use Jikkoku;
use Test::More;
use Test::Exception;

my $CLASS = 'Jikkoku::Exception';
use_ok $CLASS;

dies_ok { $CLASS->throw(" throw exception. ") };
my $e = $@;
is $e->message, " throw exception. ";
my $stact_trace = $e;
is $stact_trace, $e->stack_trace;
like $e->stack_trace, qr/throw exception/;
like $e->stack_trace, qr/Test::Exception::dies_ok\(\) called at/;

{
  local $@;
  dies_ok { $e->rethrow };
  is $stact_trace, $@->stack_trace;
}

done_testing;
