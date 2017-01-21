package Data::List::CircularlyLinked {

  use v5.14;
  use warnings;
  use List::Util qw/first/;
  use Data::List::CircularlyLinked::Node;

  sub new {
    my ($class, @data_list) = @_;
    my @array = map { Data::List::CircularlyLinked::Node->new(body => $_); } @data_list;

    for (0 .. $#array - 1) {
      $array[$_]->next( $array[$_ + 1] );
    }
    # circularly
    $array[$#array]->next( $array[0] );

    # overloadがおかしくなるのでnewの後でweakenできない
    $_->weak_next for @array;

    bless \@array, $class;
  }

  # 循環リストなので無限ループ
  sub trace {
    my $self = shift;
    _trace($self->[0]);
  }

  sub _trace {
    my $node = shift;
    _trace($node->next);
  }

  sub get {
    my ($self, $data) = @_;
    first { $data eq $_->body } @$self;
  }

}

1;

