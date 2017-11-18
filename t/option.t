use Jikkoku;
use Test::More;
use Test::Exception;

use_ok 'Option';
use Option;

subtest 'match' => sub {
  my $option = option('SOMETHING');
  my $ret = $option->match(
    Some => sub { 200 },
    None => sub { 404 },
  );
  is $ret, 200;

  my $none = option(undef);
  my $ret_2 = $none->match(
    Some => sub { 200 },
    None => sub { 404 },
  );
  is $ret_2, 404;
};

subtest 'fold' => sub {
  ok my $none = option(undef);
  dies_ok { $none->fold(sub { die 'undef' })->(sub { 'some' }) };
  ok my $some = option('string');
  is $some->fold(sub { die 'undef' })->(sub { $_ . '_value' }), 'string_value';
};

subtest 'flatten' => sub {

  my $func = sub {
    my ($c1, $c2) = @_;
    my ($v1, $v2) = (option($c1), option($c2));
    $v1->map(sub { my $s1 = $_; $v2->map(sub { my $s2 = $_; $s1 * $s2 }) })->flatten;
  };

  $func->(5, 6)->map(sub { is $_, 30 });
  ok $func->(5, undef)->isa('Option::None');
  ok $func->(undef, 6)->isa('Option::None');
  ok $func->(undef, undef)->isa('Option::None');

  my $func2 = sub {
    my @args = @_;
    my ($v1, $v2, $v3, $v4) = map { option($_) } @args;
    $v1->map(sub {
      my $s1 = shift;
      $v2->map(sub {
        my $s2 = shift;
        $v3->map(sub {
          my $s3 = shift;
          $v4->map(sub {
            my $s4 = shift;
            $s1 * $s2 * $s3 * $s4;
          })
        })->flatten
      })->flatten
    })->flatten
  };
  
  my $some = $func2->(6, 4, 2, 5);
  $some->map(sub { is $_, 240 });
  ok $func2->(6, 4, 2, undef)->isa('Option::None');
  ok $func2->(6, 4, undef, 5)->isa('Option::None');
  ok $func2->(undef, 4, 2, 5)->isa('Option::None');
  ok $func2->(undef, undef, undef, undef)->isa('Option::None');

};

subtest 'flat_map' => sub {

  my $func = sub {
    my @args = @_;
    my ($v1, $v2, $v3, $v4) = map { option($_) } @args;
    $v1->flat_map(sub {
      my $s1 = shift;
      $v2->flat_map(sub {
        my $s2 = shift;
        $v3->flat_map(sub {
          my $s3 = shift;
          $v4->map(sub {
            my $s4 = shift;
            $s1 * $s2 * $s3 * $s4;
          })
        })
      })
    })
  };

  my $some = $func->(6, 4, 2, 5);
  $some->map(sub { is $_, 240 });
  ok $func->(6, 4, 2, undef)->isa('Option::None');
  ok $func->(6, 4, undef, 5)->isa('Option::None');
  ok $func->(undef, 4, 2, 5)->isa('Option::None');
  ok $func->(undef, undef, undef, undef)->isa('Option::None');

};

subtest 'to_list' => sub {

  ok my $opt = option(option(option(100)));
  my $val = do {
    my ($opt1, $has_100) = $opt->to_list;
    $has_100;
  }->get_or_else(404);
  is $val, 100;

  ok my $none = option(option(none));
  my $val2 = do {
    my ($opt1, $has_100) = $none->to_list;
    $has_100;
  }->get_or_else(404);
  is $val2, 404;

};

subtest 'like scala for' => sub {

  my $result = flat_option {
    my ($n1, $n2, $n3, $n4) = @_;
    $n1 * $n2 * $n3 * $n4;
  } map { option $_ } (6, 4, 2, 5);
  $result->map(sub { is $_, 240 });

  $result = flat_option {
    my ($n1, $n2, $n3, $n4) = @_;
    $n1 * $n2 * $n3 * $n4;
  } map { option $_ } (6, 4, undef, 5);
  ok $result->isa('Option::None');

  $result = flat_option {
    my ($n1, $n2, $n3, $n4) = @_;
    $n1 * $n2 * $n3 * $n4;
  } map { option $_ } (undef, undef, undef, undef);
  ok $result->isa('Option::None');

};

done_testing;

