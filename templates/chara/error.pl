use Jikkoku;
use Jikkoku::Template;

my $layout = take_in 'templates/layouts/chara.pl';

sub {
  my $args = shift;

  my $this = sub {
    qq{
      <center>
        <hr>
        <h1 class="red">ERROR !!</h1>
        <span class="red"><strong>『$args->{message}』</strong></span>
        <br>
        <form action="@{[ $args->{return_url} ]}" method="POST">
          <input type="hidden" name="id" value="@{[ $args->{chara}->id ]}">
          <input type="hidden" name="pass" value="@{[ $args->{chara}->pass ]}">
          <input type="hidden" name="mode" value="@{[ $args->{return_mode} ]}">
          <input type="submit" value="戻る">
        </form>
        <hr>
      </center>
    };
  };

  $layout->($this, $args);
};

