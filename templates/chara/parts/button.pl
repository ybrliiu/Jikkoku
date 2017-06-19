use Jikkoku;
use Jikkoku::Template;
use Carp ();

sub {
  my $args = shift;

  sub {
    my $params = shift // {};
    $args->{class} //= [];
    qq{
      <form action="$args->{url}" method="POST" class="@{[ join ' ', @{ $args->{class} } ]}">
    } . ( join '', map {
      qq{<input type="hidden" name="$_" value="$params->{$_}">\n}
    } keys %$params ) . qq{
        <input type="hidden" name="id" value="@{[ $args->{chara}->id ]}">
        <input type="hidden" name="pass" value="@{[ $args->{chara}->pass ]}">
        <input type="submit" value="$args->{name}">
      </form>
    };
  };
};
