package Jikkoku::Web {

  use Jikkoku;
  use Module::Load;
  use Jikkoku::Web::Router;
  use Jikkoku::Web::Controller;

  our $ABSOLUTERY_URL;

  sub new {
    my ($class, $script_name) = @_;

    unless (defined $ABSOLUTERY_URL) {
      $ABSOLUTERY_URL = $ENV{HTTP_HOST} . $ENV{SCRIPT_NAME};
      my ($file_name) = ($ABSOLUTERY_URL =~ m!([^/]+$)!);
      $ABSOLUTERY_URL =~ s/$file_name//g;
    }

    my $self = bless {router => Jikkoku::Web::Router->new}, $class;
    $self->dispatch;

    $self;
  }

  sub dispatch {
    my $self = shift;
    my $router = $self->{router};

    my $chara = $router->root(
      path       => '/chara',
      controller => 'Jikkoku::Web::Controller::Chara'
    );
    $chara->any('/');
    $chara->any('/battle-map');

    {
      my $battle_command = $chara->root(path => '/battle-action', controller => 'BattleAction');
      $battle_command->any('/move');
      $battle_command->any('/charge-move-point');
      $battle_command->any('/stuck');
    }

    {
      my $battle_action_reservation = $chara->root(path => '/battle-action-reseration', controller => 'BattleActionReservation');
      $battle_action_reservation->any('/');
      $battle_action_reservation->any('/input');
    }

    {
      my $headquarters = $chara->root(path => '/country/headquarters', controller => 'Country::Headquarters');
      $headquarters->any('/');

      {
        my $diplomacy = $headquarters->root(path => '/diplomacy', controller => 'Diplomacy');
        $diplomacy->any('/');

        {
          my $request = $diplomacy->root(path => '/request', controller => 'Request');
          $request->any('/declare-war');
          $request->any('/short-declare-war');
          $request->any('/cease-war');
          $request->any('/cession-or-accept-territory');
          $request->any('/allow-passage');
        }

        {
          my $accept = $diplomacy->root(path => '/accept', controller => 'Accept');
          $accept->any('/short-declare-war');
          $accept->any('/cease-war');
          $accept->any('/cession-or-accept-territory');
          $accept->any('/allow-passage');
        }

        {
          my $withdraw = $diplomacy->root(path => '/withdraw', controller => 'Withdraw');
          $withdraw->any('/cession-or-accept-territory');
          $withdraw->any('/allow-passage');
        }
      }

    }
  }

  sub run {
    my $self = shift;
    my ($dest, $capture, $is_method_allowed)
      = $self->{router}->match($ENV{REQUEST_METHOD}, $ENV{PATH_INFO});

    if (%$dest && $is_method_allowed) {
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
