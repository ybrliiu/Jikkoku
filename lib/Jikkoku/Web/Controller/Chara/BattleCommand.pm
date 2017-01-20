package Jikkoku::Web::Controller::Chara::BattleCommand {

  use Jikkoku;
  use parent 'Jikkoku::Web::Controller::Chara::Base';
  use Jikkoku::Template;

  sub new {
    my $class = shift;
    my $self  = $class->SUPER::new(@_);
    $self->{return_url_origin} = '/chara/battle-map';
    $self->{return_url}        = url_for $self->{return_url_origin};
    $self;
  }

  sub move {
    my $self = shift;

    my $move = $self->class('BattleCommand::Move')->new({ chara => $self->{chara} });

    eval {
      $move->action({
        direction        => $self->param('direction'),
        town_model       => $self->model('Town')->new,
        chara_model      => $self->model('Chara')->new,
        battle_map_model => $self->model('BattleMap')->new,
      });
    };

    if (my $e = $@) {
      $self->render_error($e);
    }

    $self->redirect_to($self->{return_url_origin});
  }

  sub charge_move_point {
    my $self = shift;

    my $charger = $self->class('BattleCommand::ChargeMovePoint')->new({ chara => $self->{chara} });

    eval { $charger->action };
    if (my $e = $@) {
      $self->render_error($e);
    }

    $self->redirect_to($self->{return_url_origin});
  }

  sub stuck {
    my $self = shift;

    my $stuck = $self->class('Skill::Disturb::Stuck')->new({ chara => $self->{chara} });

    eval {
      $stuck->action({
        target_id => $self->param('target_id') || undef,
        chara_model      => $self->{chara_model},
        map_log_model    => $self->model('MapLog')->new,
        battle_map_model => $self->model('BattleMap')->new,
      });
    };
    if (my $e = $@) {
      $self->render_error($e);
    }

    $self->render('chara/result.pl', {message => $stuck->name . "を行いました。"});
  }


}

1;
