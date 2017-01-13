package Jikkoku::Web {

  use Jikkoku;
  use Module::Load;
  use Router::Boom;
  use Jikkoku::Web::Controller;

  our $ABSOLUTERY_URL;

  sub new {
    my ($class, $script_name) = @_;

    unless (defined $ABSOLUTERY_URL) {
      $ABSOLUTERY_URL = $ENV{HTTP_HOST} . $ENV{SCRIPT_NAME};
      my ($file_name) = ($ABSOLUTERY_URL =~ m!([^/]+$)!);
      $ABSOLUTERY_URL =~ s/$file_name//g;
    }

    my $self = bless {router => Router::Boom->new}, $class;
    $self->dispatch;

    $self;
  }

  sub dispatch {
    my $self = shift;
    my $router = $self->{router};

    my $root = '/chara';
    my $controller = 'Jikkoku::Web::Controller::Chara';
    $router->add("$root/",               {controller => $controller});
    $router->add("$root/battle-map", {controller => $controller});

    {
      my $root = '/chara/country/headquarters';
      my $controller = 'Jikkoku::Web::Controller::Chara::Country::Headquarters';
      $router->add("$root/", {controller => $controller});

      {
        my $root = "$root/diplomacy";
        my $controller = "${controller}::Diplomacy";
        $router->add("$root/", {controller => $controller});

        {
          my $root = "$root/request";
          my $controller = "${controller}::Request";
          $router->add("$root/declare-war",                 {controller => $controller});
          $router->add("$root/short-declare-war",           {controller => $controller});
          $router->add("$root/cease-war",                   {controller => $controller});
          $router->add("$root/cession-or-accept-territory", {controller => $controller});
          $router->add("$root/allow-passage",               {controller => $controller});
        }

        {
          my $root = "$root/accept";
          my $controller = "${controller}::Accept";
          $router->add("$root/short-declare-war",           {controller => $controller});
          $router->add("$root/cease-war",                   {controller => $controller});
          $router->add("$root/cession-or-accept-territory", {controller => $controller});
          $router->add("$root/allow-passage",               {controller => $controller});
        }

        {
          my $root = "$root/withdraw";
          my $controller = "${controller}::Withdraw";
          $router->add("$root/cession-or-accept-territory", {controller => $controller});
          $router->add("$root/allow-passage",               {controller => $controller});
        }
      }

    }
  }

  sub run {
    my $self = shift;
    my ($dest, $capture) = $self->{router}->match( $ENV{PATH_INFO} );
    # rooter 継承して...
    uri_to_action($dest, $ENV{PATH_INFO});

    if (defined $dest) {
      my $controller = $dest->{controller};
      my $action     = $dest->{action};
      load $controller;
      my $c = $controller->new;
      $c->$action;
    } else {
      my $c = Jikkoku::Web::Controller->new;
      $c->render_error('そのページは存在しません');
    }
  }

  sub uri_to_action($$) {
    my ($dest, $path_info) = @_;
    my ($last_uri) = ($path_info =~ m!([^/]+$)!);
    unless (exists $dest->{action}) {
      $dest->{action} = $last_uri ? $last_uri =~ s/-/_/gr : 'root';
    }
  }

}

1;
