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

  sub charge_move_point {
    my $self = shift;

    my $charger = $self->service('BattleCommand::ChargeMovePoint')->new({ chara => $self->chara });

    eval { $charger->exec };
    if (my $e = $@) {
      $self->render_error($e->message);
    }

    $self->redirect_to($self->return_url_origin);
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

  __PACKAGE__->meta->make_immutable;

}

1;
