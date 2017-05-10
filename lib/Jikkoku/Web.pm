package Jikkoku::Web {

  use Mouse;
  use Jikkoku;

  use Module::Load;
  use Jikkoku::Web::Router;

  our $ABSOLUTERY_URL;

  has 'router' => ( is => 'ro', isa => 'Jikkoku::Web::Router', default => sub { Jikkoku::Web::Router->new } );

  sub BUILD {
    my $self = shift;

    unless (defined $ABSOLUTERY_URL) {
      $ABSOLUTERY_URL = $ENV{HTTP_HOST} . $ENV{SCRIPT_NAME};
      my ($file_name) = ($ABSOLUTERY_URL =~ m!([^/]+$)!);
      $ABSOLUTERY_URL =~ s/$file_name//g;
    }

    $self->dispatch;
  }

  sub dispatch {
    my $self = shift;
    my $router = $self->router;

    my $chara = $router->root(
      path       => '/chara',
      controller => 'Jikkoku::Web::Controller::Chara',
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
      = $self->router->match($ENV{REQUEST_METHOD}, $ENV{PATH_INFO});

    if (%$dest && $is_method_allowed) {
      my $controller = $dest->{controller};
      my $action     = $dest->{action};
      state $is_loaded = {};
      unless ($is_loaded->{$controller}) {
        load $controller;
        $is_loaded->{$controller} = 1;
      }
      my $c = $controller->new;
      $c->$action;
    } else {
      # Jikkoku::Template が2度よみこまれる妙なエラーの抑止のためrequireを使用
      require Jikkoku::Web::Controller;
      my $c = Jikkoku::Web::Controller->new;
      $c->render_error('そのページは存在しません');
    }
  }

  __PACKAGE__->meta->make_immutable;

}

1;

