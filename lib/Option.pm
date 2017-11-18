package Option {

  use v5.14;
  use warnings;

  our $VERSION = '0.03';

  use Carp;
  use Option::Some;
  use Option::None;

  use Exporter qw( import );
  our @EXPORT = qw( option some none flat_option );

  sub option($) {
    defined $_[0] ? Option::Some->new($_[0]) : Option::None->new;
  }

  sub some($) { Option::Some->new($_[0]) }

  sub none { Option::None->new() }

  sub _rec {
    my ($options, $index, $params, $code) = @_;
    if ($index == @$options - 1) {
      $options->[$index]->map(sub {
        my $c = shift;
        $code->(@$params, $c);
      });
    } else {
      $options->[$index]->flat_map(sub {
        my $c = shift;
        push @$params, $c;
        _rec($options, $index + 1, $params, $code);
      });
    }
  }

  sub flat_option(&@) {
    my ($code, @options) = @_;
    _rec(\@options, 0, [], $code);
  }

  # deprecated
  sub new {
    my ($class, $contents) = @_;
    option($contents);
  }

}

1;

__END__

=encoding utf8

=head1 NAME
  
  Option - Option class like Scala.Option.

=head1 SINOPSYS

=head1 FUNCTIONS
  
=head2 flat_option
  
  like scala for expression.

  my ($v1, $v2, $v3) = map { option $_ } (2, 4, 6);
  my $result = flat_option {
    my ($i1, $i2, $i3) = @_;
    $i1 * $i2 * $i3;
  } ($v1, $v2, $v3);

  same :

  for ( i1 <- v1; i2 <- v2; i3 <- v3 ) yield { i1 * i2 * i3 }

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

