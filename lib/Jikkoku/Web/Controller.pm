package Jikkoku::Web::Controller {

  use Mouse;
  use Jikkoku;

  use CGI;
  use Carp;
  use Module::Load;
  use Jikkoku::Template;
  use Jikkoku::Model::Config;

  my $CONFIG = Jikkoku::Model::Config->get;

  has 'cgi' => (
    is      => 'ro',
    isa     => 'CGI',
    default => sub { CGI->new },
    handles => [qw/ header param redirect /],
  );

  with 'Jikkoku::Role::Loader';

  sub render {
    my ($self, $template_file, $args) = @_;
    Carp::croak("テンプレートファイルを指定してください") unless defined $template_file;
    $args //= {};

    $args->{config}    = $CONFIG;
    $args->{CSS_FILES} //= [];
    $args->{JS_FILES}  //= [];
    $self->hook_before_render( $args );

    my $header = $self->header(
      -cache_control => 'no-cache',
      -pragma        => 'no-cache',
      -charset       => 'UTF-8',
    );
    my $template = take_in "templates/${template_file}";
    my $result = eval {
      $template->( $args );
    };

    print $header;
    if (my $e = $@) {
      my $error = take_in "templates/error.pl";
      $args->{message} = $e;
      print $error->( $args );
    } else {
      print $result;
    }

  }

  sub hook_before_render {}

  sub render_error {
    my ($self, $message) = @_;
    Carp::croak 'few arguments($message)' if @_ < 2;
    $self->render('error.pl', {message => $message});
    exit;
  }

  sub redirect_to {
    my ($self, $path) = @_;
    Carp::croak 'few arguments($path)' if @_ < 2;
    print $self->redirect( url_for $path );
    exit;
  }

  __PACKAGE__->meta->make_immutable;

}

1;
