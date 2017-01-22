package Option {

  use v5.14;
  use warnings;
  use Carp;
  
  sub new {
    Carp::confess "few arguments" if @_ < 2;
    my ($class, $data) = @_;
    bless { contents => $data }, $class;
  }

  sub foreach {
    Carp::confess "few arguments" if @_ < 2;
    my ($self, $code) = @_;
    Carp::confess "please specify CodeRef" if ref $code ne 'CODE';
  }

  sub get {}

  sub get_or_else {
    Carp::confess "few arguments" if @_ < 2;
  }

  sub is_defined {}

  sub is_empty {}

  sub match {
    Carp::confess "few arguments" if @_ < 5;
    my ($self, %args) = @_;
    for (qw/Some None/) {
      my $code = $args{$_};
      Carp::confess " please specify process $_ " if ref $code ne 'CODE';
    }
  }

}

1;

=head1 NAME
  
  Option - Option like Scala Option.

=head1 MEMO

  Option --- Some
          |- None

  Option->match(
    Some => sub { shift },
    None => sub {},
  );
  Option->get_or_else("default value");
  Option->or_else( default_option->new() );
  Some->get;
  None->get; # No Such Element Exception
  Option->foreach(sub { "値があるときのみ" });
  Some->is_defined; # true
  None->is_defined; # false
  Some->exists(sub { shift != 0 }); # 条件付きの is_defined
  Some->is_empty;   # false
  None->is_empty;   # true

=cut

