use Jikkoku;
use Jikkoku::Template;

sub {
  my $args = shift;

  sub {
    my $params = shift // {};
    qq{
      <form action="$args->{url}" method="POST">
        <input type="hidden" name="mode" value="$args->{mode}">
    } . ( join '', map {
      qq{<input type="hidden" name="$_" value="$params->{$_}">}
    } keys %$params ) . qq{
        <input type="hidden" name="id" value="@{[ $args->{chara}->id ]}">
        <input type="hidden" name="pass" value="@{[ $args->{chara}->pass ]}">
        <input type="submit" value="$args->{name}">
      </form>
    };
  };
};
