package TieSTDOUT {

  use v5.24;
  use warnings;

  sub TIEHANDLE {
    my ($class) = @_;
    bless [], $class;
  }

  sub PRINT {
    my ($self, @args) = @_;
    push @$self, $_ for @args;
  }

  sub lines {
    my ($self) = @_;
    @$self;
  }

  sub to_s {
    my ($self) = @_;
    join "\n", @$self;
  }

}

1;
