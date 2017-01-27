use Jikkoku;
use Test::More;
use Test::Exception;

use_ok 'Option';

subtest 'match' => sub {
  my $option = Option->new('SOMETHING');
  my $ret = $option->match(
    Some => sub { 200 },
    None => sub { 404 },
  );
  is $ret, 200;

  my $none = Option->new(undef);
  my $ret_2 = $none->match(
    Some => sub { 200 },
    None => sub { 404 },
  );
  is $ret_2, 404;
};

subtest 'like for-each-yield' => sub {
  ok my $opt = Option->new( Option->new( Option->new(100) ) );
  my $val = do {
    my ($opt1, $has_100) = $opt->to_list;
    $has_100;
  }->get_or_else(404);
  is $val, 100;

  ok my $none = Option->new( Option->new( Option::None->new ) );
  my $val2 = do {
    my ($opt1, $has_100) = $none->to_list;
    $has_100;
  }->get_or_else(404);
  is $val2, 404;
};

done_testing;
