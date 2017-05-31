use v5.24;
use warnings;
use Test::More;
use Test::Exception;

use_ok 'Jikkoku::Role::Singleton';

package Point {
  use Mouse;
  use Jikkoku;
  with 'Jikkoku::Role::Singleton';
  has 'x' => ( is => 'ro', isa => 'Int', required => 1 );
  has 'y' => ( is => 'ro', isa => 'Int', required => 1 );
  __PACKAGE__->meta->make_immutable;
}

package Warm {
  use Mouse;
  use Jikkoku;
  with 'Jikkoku::Role::Singleton';
  has 'name' => ( is => 'ro', isa => 'Str', required => 1 );
  has 'type' => ( is => 'ro', isa => 'Str', required => 1 );
  __PACKAGE__->meta->make_immutable;
}

my $point;
lives_ok { $point = Point->instance(x => 0, y => 2) };
my $point2;
lives_ok { $point2 = Point->instance({x => 3, y => 2}) };
is $point, $point2;

my $warm = Warm->instance({name => '毛虫', type => '不明'});
my $warm2 = Warm->instance(name => 'イモムシ', type => '不明');
is $warm, $warm2;

done_testing;

