package Jikkoku::Template {

  use Jikkoku;
  use Exporter 'import';
  our @EXPORT = qw( take_in );

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

}

1;
