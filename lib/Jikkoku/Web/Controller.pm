package Jikkoku::Web::Controller {

  use Mouse;
  use Jikkoku;
  use Carp;
  use HTTP::Headers;
  use Plack::Request;
  use Plack::Response;
  use Module::Load;
  use Jikkoku::Template qw( take_in );
  use Jikkoku::Model::Config;

  use constant {
    # success
    OK      => 200,
    CREATED => 201,

    # redirection
    TEMPORARY_REDIRECT => 307,
    PERMANENT_REDIRECT => 308,

    # client error
    BAD_REQUEST  => 400,
    UNAUTHORIZED => 401,
    FORBIDDEN    => 403,
    NOT_FOUND    => 404,

    # server error
    INTERNAL_SERVER_ERROR => 500,
  };

  my $CONFIG = Jikkoku::Model::Config->get;

  has 'env' => (
    is       => 'ro',
    isa      => 'HashRef',
    required => 1,
  );

  has 'req' => (
    is      => 'ro',
    isa     => 'Plack::Request',
    lazy    => 1,
    handles => [qw/ param /],
    builder => '_build_req',
  );

  sub _build_req {
    my $self = shift;
    Plack::Request->new($self->env);
  }

  with 'Jikkoku::Role::Loader';

  sub render {
    my ($self, $template_file, $args) = @_;
    Carp::croak("テンプレートファイルを指定してください") unless defined $template_file;
    $args //= {};

    $args->{config}    = $CONFIG;
    $args->{CSS_FILES} //= [];
    $args->{JS_FILES}  //= [];

    $self->hook_before_render($args);

    my $header = HTTP::Headers->new(
      Pragma           => 'no-cache',
      Content_Type     => 'text/html; charset=UTF-8',
      Cache_Control    => 'no-cache',
      Content_Language => 'ja',
    );

    my $template = take_in "templates/${template_file}";
    my $body = eval { $template->($args) };
    my $res = do {
      if (my $e = $@) {
        my $error = take_in "templates/error.pl";
        $args->{message} = $e;
        my $body = $error->($args);
        Plack::Response->new(INTERNAL_SERVER_ERROR, $header, $body);
      } else {
        Plack::Response->new(OK, $header, $body);
      }
    };
    $res->finalize;
  }

  sub hook_before_render {}

  sub render_error {
    my ($self, $message) = @_;
    Carp::croak 'Too few arguments (required: $message)' if @_ < 2;
    $self->render('error.pl', {message => $message});
  }

  sub redirect_to {
    my ($self, $path) = @_;
    Carp::croak 'Too few arguments (required: $path)' if @_ < 2;
    my $res = Plack::Response->new($path);
    $res->redirect;
  }

  __PACKAGE__->meta->make_immutable;

}

1;
