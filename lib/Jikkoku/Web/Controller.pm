package Jikkoku::Web::Controller {

  use Jikkoku;
  use parent 'CGI';

  use Carp;
  use Module::Load;
  use Jikkoku::Template;
  use Jikkoku::Model::Config;

  my $CONFIG = Jikkoku::Model::Config->get;

  sub render {
    my ($self, $template_file, $args) = @_;
    Carp::croak(" テンプレートファイルを指定してください ") unless defined $template_file;
    $args //= {};

    $args->{config} = $CONFIG;
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
    Carp::croak "引数が足りません" if @_ < 2;
    $self->render('error.pl', {message => $message});
    exit;
  }

  sub class {
    my ($self, $class_name) = @_;
    my $pkg = "Jikkoku::Class::${class_name}";
    load $pkg;
    $pkg;
  }

  sub model {
    my ($self, $class_name) = @_;
    my $pkg = "Jikkoku::Model::${class_name}";
    load $pkg;
    $pkg;
  }

}

1;
