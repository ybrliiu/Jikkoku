package Jikkoku::Web::Controller::Chara::Base {

  use Jikkoku;
  use parent 'Jikkoku::Web::Controller';

  use Carp;
  use Jikkoku::Util qw/validate_values/;
  use Jikkoku::Template;

  sub new {
    my $class = shift;
    my $self = $class->SUPER::new( @_ );

    $self->{chara}       = undef;
    $self->{return_url}  = static_file 'status.cgi';
    $self->{return_mode} = 'STATUS';

    $self->auth;
    $self;
  }

  sub auth {
    my $self = shift;
    $self->{chara_model} = $self->model('Chara')->new;
    $self->{chara_model}
      ->opt_get( $self->param('id') )
      ->match(
        Some => sub {
          my $chara = shift;
          $self->SUPER::render_error("ID, もしくはパスワードが間違っています。")
            unless $chara->check_pass( $self->param('pass') );
          $self->{chara} = $chara;
        },
        None => sub {
          $self->SUPER::render_error("ID, もしくはパスワードが間違っています。");
        },
      );
  }
  
  # override
  sub hook_before_render {
    my ($self, $args) = @_;
    if (defined $self->{chara}) {
      $args->{chara}       = $self->{chara};
      $args->{font_size}   = $self->{chara}->config('font_size');
      $args->{return_url}  = $self->{return_url};
      $args->{return_mode} = $self->{return_mode};
    }
  }

  # override
  sub redirect_to {
    my ($self, $path) = @_;
    $path .= '?id=' . $self->{chara}->id . '&pass=' . $self->{chara}->pass;
    $self->SUPER::redirect_to($path);
  }

  # override
  sub render_error {
    my ($self, $message) = @_;
    Carp::croak "引数が足りません" if @_ < 2;
    $self->render('chara/error.pl', {message => $message});
    exit;
  }

}

1;
