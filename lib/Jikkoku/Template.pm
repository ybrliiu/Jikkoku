package Jikkoku::Template {

  use Jikkoku;
  use Jikkoku::Web;
  use Exporter 'import';
  our @EXPORT = qw/take_in url_for static_file/;

  use Carp ();
  use Cwd ();
  use File::Basename ();

  our %TEMPLATE;

  sub take_in {
    my $template_file = shift;
    my $file = (caller)[1];
  
    my $template;
    my $err;
    {
      local @INC = ('', Cwd::getcwd, File::Basename::dirname($file));
      push @INC, $TEMPLATE{path} if defined $TEMPLATE{path};
  
      $template = do $template_file;
      $err = $!;
    }
  
    Carp::croak $@ if $@;
    Carp::croak $err unless defined $template;
    unless (ref $template eq 'CODE') {
      Carp::croak "$template_file does not return CodeRef.";
    }
  
    $template;
  }

  sub static_file {
    my $static_file = shift;
    'http://' . $Jikkoku::Web::ABSOLUTERY_URL . $static_file;
  }

  sub url_for {
    my $url = shift;
    "http://$ENV{HTTP_HOST}$ENV{SCRIPT_NAME}$url";
  }

}

1;
