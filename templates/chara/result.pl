use Jikkoku;
use Jikkoku::Template;

my $layout = take_in 'templates/layouts/chara.pl';

sub {
  my $args = shift;

  my $this = sub {
    qq{
      <center>
        <h1>$args->{message}</h1>
        <form action="@{[ $args->{return_url} ]}" method="POST">
          <input type="hidden" name="id" value="@{[ $args->{chara}->id ]}">
          <input type="hidden" name="pass" value="@{[ $args->{chara}->pass ]}">
          <input type="hidden" name="mode" value="@{[ $args->{return_mode} ]}">
          <input type="submit" value="戻る">
        </form>
      </center>
    };
  };

  $layout->($this, $args);
};

