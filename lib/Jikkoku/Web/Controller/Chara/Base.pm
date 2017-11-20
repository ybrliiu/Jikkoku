package Jikkoku::Web::Controller::Chara::Base {

  use Mouse;
  use Jikkoku;

  extends 'Jikkoku::Web::Controller';

  use Carp;
  use Jikkoku::Util qw( validate_values );
  use Jikkoku::Template;

  has 'chara'       => ( is => 'rw', isa => 'Jikkoku::Class::Chara::ExtChara', lazy_build => 1 );
  has 'return_url'  => ( is => 'ro', isa => 'Str', default => sub { static_file 'status.cgi' } );
  has 'return_mode' => ( is => 'ro', isa => 'Str', default => 'STATUS' );

  has 'chara_model' => (
    is      => 'ro',
    isa     => 'Jikkoku::Model::Chara',
    lazy    => 1,
    default => sub {
      my $self = shift;
      $self->model('Chara')->new;
    },
  );

  sub _build_chara {
    my $self = shift;
    my $id = $self->param('id');
    $self->SUPER::render_error("IDを入力してください。") unless defined $id;
    $self->chara_model
      ->get_with_option($id)
      ->match(
        Some => sub {
          my $chara = shift;
          $self->SUPER::render_error("ID, もしくはパスワードが間違っています。")
            unless $chara->check_pass( $self->param('pass') );
          $self->class('Chara::ExtChara')->new(chara => $chara);
        },
        None => sub {
          $self->SUPER::render_error("ID, もしくはパスワードが間違っています。");
        },
      );
  }

  sub BUILD {
    my $self = shift;
    $self->chara;
  }

  override hook_before_render => sub {
    my ($self, $args) = @_;
    if ( $self->has_chara ) {
      $args->{chara}       = $self->chara;
      $args->{font_size}   = $self->chara->config('font_size');
      $args->{return_url}  = $self->return_url;
      $args->{return_mode} = $self->return_mode;
    }
  };

  override redirect_to => sub {
    my ($self, $path) = @_;
    $path .= '?id=' . $self->chara->id . '&pass=' . $self->chara->pass;
    $self->SUPER::redirect_to($path);
  };

  override render_error => sub {
    my ($self, $message) = @_;
    Carp::croak 'Too few arguments (required: $message)' if @_ < 2;
    $self->render('chara/error.pl', {message => $message});
    exit;
  };

  __PACKAGE__->meta->make_immutable;

}

1;
