package Jikkoku::Web::Controller::Chara::BattleAction {

  use Mouse;
  use Jikkoku;

  extends 'Jikkoku::Web::Controller::Chara::Base';

  use Jikkoku::Template;

  has 'return_url_origin' => (
    is      => 'ro',
    isa     => 'Str',
    default => '/chara/battle-map',
  );

  has 'return_url' => (
    is      => 'ro',
    isa     => 'Str',
    lazy    => 1,
    default => sub {
      my $self = shift;
      url_for $self->return_url_origin;
    },
  );

  sub move {
    my $self = shift;

    my $move = $self->service('BattleCommand::Move')->new({
      chara     => $self->chara,
      direction => $self->param('direction'),
    });

    eval { $move->exec };

    if (my $e = $@) {
      $self->render_error($e->message);
    }

    $self->redirect_to($self->return_url_origin);
  }

  sub change_formation {
    my $self = shift;
    my $formation_id = $self->param('formation-id');
    my $service = $self->service('Chara::Soldier::ChangeFormation')->new({
      chara               => $self->chara,
      change_formation_id => $formation_id,
    });
    my $formation = eval { $service->exec };
    if (my $e = $@) {
      if ( Jikkoku::Exception->caught($e) ) {
        $self->render_error($e->message);
      } else {
        $self->render_error($e);
      }
    }
    $self->render('chara/result.pl', {message => $formation->name . 'に変更しました。'});
  }

  sub charge_move_point {
    my $self = shift;

    my $charger = $self->service('BattleCommand::ChargeMovePoint')->new({ chara => $self->chara });

    eval { $charger->exec };
    if (my $e = $@) {
      $self->render_error($e->message);
    }

    $self->redirect_to($self->return_url_origin);
  }

  sub exit {
    my $self = shift;
    my ($check_point_x, $check_point_y) = map { $self->param($_) } qw( check_point_x check_point_y );
    my $service = $self->service('BattleCommand::Exit')->new({
      chara         => $self->chara,
      check_point_x => $check_point_x,
      check_point_y => $check_point_y,
    });
    eval { $service->exec };
    if (my $e = $@) {
      $self->render_error( Jikkoku::Exception->caught($e) ? $e->message : $e );
    }
    $self->redirect_to( $self->return_url_origin );
  }

  sub entry {
    my $self = shift;
    my ($check_point_x, $check_point_y) = map { $self->param($_) } qw( check_point_x check_point_y );
    my $service = $self->service('BattleCommand::Entry')->new({
      chara         => $self->chara,
      check_point_x => $check_point_x,
      check_point_y => $check_point_y,
    });
    eval { $service->exec };
    if (my $e = $@) {
      $self->render_error( Jikkoku::Exception->caught($e) ? $e->message : $e );
    }
    $self->redirect_to( $self->return_url_origin );
  }

  sub stuck {
    my $self = shift;

    my $stuck = $self->class('Skill::Disturb::Stuck')->new({ chara => $self->chara });

    eval {
      $stuck->exec({
        target_id => $self->param('target_id') || undef,
        chara_model      => $self->chara_model,
        map_log_model    => $self->model('MapLog')->new,
        battle_map_model => $self->model('BattleMap')->new,
      });
    };
    if (my $e = $@) {
      $self->render_error($e->message);
    }

    $self->render('chara/result.pl', {message => $stuck->name . "を行いました。"});
  }

  sub switch_bm_auto_mode {
    my $self = shift;

    my $mode = $self->param('switch_mode');
    unless ( grep { $mode eq $_ } qw/ ON OFF / ) {
      return $self->render_error('不正な値が含まれています');
    }

    my $service = $self->service('Chara::SwitchBattleMapAutoMode')->new(chara => $self->chara);
    eval {
      if ($mode eq 'ON') {
        $service->on;
      } else {
        $service->off;
      }
    };
    if (my $e = $@) {
      $self->render_error( Jikkoku::Exception->caught($e) ? $e->message : $e );
    }
    $self->render('chara/result.pl', {message => $mode . 'にしました。'});
  }

  __PACKAGE__->meta->make_immutable;

}

1;
