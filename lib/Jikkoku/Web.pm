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

    bless {router => Router::Boom->new}, $class;
  }

  sub dispatch {
    my $self = shift;
    my $router = $self->{router};

    {
      my $root = '/chara/country/headquarters';
      my $controller = 'Jikkoku::Web::Controller::Chara::Country::Headquarters';
      $router->add("$root/",                   {controller => $controller, action => 'root'});

      {
        my $root = "$root/diplomacy";
        my $controller = "${controller}::Diplomacy";
        $router->add("$root/", {controller => $controller, action => 'root'});

        {
          my $root = "$root/request";
          my $controller = "${controller}::Request";
          $router->add("$root/declare-war",                 {controller => $controller, action => 'declare_war'});
          $router->add("$root/short-declare-war",           {controller => $controller, action => 'short_declare_war'});
          $router->add("$root/cease-war",                   {controller => $controller, action => 'cease_war'});
          $router->add("$root/cession-or-accept-territory", {controller => $controller, action => 'cession_or_accept_territory'});
          $router->add("$root/allow-passage",               {controller => $controller, action => 'allow_passage'});
        }

        {
          my $root = "$root/accept";
          my $controller = "${controller}::Accept";
          $router->add("$root/short-declare-war",           {controller => $controller, action => 'short_declare_war'});
          $router->add("$root/cease-war",                   {controller => $controller, action => 'cease_war'});
          $router->add("$root/cession-or-accept-territory", {controller => $controller, action => 'cession_or_accept_territory'});
          $router->add("$root/allow-passage",               {controller => $controller, action => 'allow_passage'});
        }

        {
          my $root = "$root/withdraw";
          my $controller = "${controller}::Withdraw";
          $router->add("$root/cession-or-accept-territory", {controller => $controller, action => 'cession_or_accept_territory'});
          $router->add("$root/allow-passage",               {controller => $controller, action => 'allow_passage'});
        }
      }

    }
  }

  sub run {
    my $self = shift;
    $self->dispatch;
    my ($dest, $capture) = $self->{router}->match( $ENV{PATH_INFO} );
    
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

}

1;
