use Jikkoku;
use Jikkoku::Template;

my $default = take_in 'templates/layouts/default.pl';

sub {
  my $args = shift;
  my $this = sub {
    qq{
      <center>
        <hr>
        <h1 class="red">ERROR !!</h1>
        <p>
          <span class="red"><strong>『$args->{message}』</strong></span>
          <form action="/" method="GET">
            <input type="submit" value="戻る">
          </form>
        </p>
        <hr>
      </center>
    };
  };
  $default->($this, $args);
};

