package Jikkoku::Web::Controller::Root {

  use Mouse;
  use Jikkoku;
  use Jikkoku::Model::Config;

  use constant {
    MAP_LOG_NUM     => 20,
    HISTORY_LOG_NUM => 20,
  };

  extends 'Jikkoku::Web::Controller';

  has 'game_date' => (
    is      => 'ro',
    isa     => 'Jikkoku::Class::GameDate',
    lazy    => 1,
    default => sub {
      my $self = shift;
      $self->container->get('common.game_date');
    },
  );

  has 'game_record' => (
    is      => 'ro',
    isa     => 'Jikkoku::Class::GameRecord',
    lazy    => 1,
    default => sub {
      my $self = shift;
      $self->container->get('common.game_record');
    },
  );

  has 'announce_model' => (
    is      => 'ro',
    isa     => 'Jikkoku::Model::Announce',
    lazy    => 1,
    default => sub {
      my $self = shift;
      $self->container->get('model.announce');
    },
  );

  has 'map_log_model' => (
    is      => 'ro',
    isa     => 'Jikkoku::Model::MapLog',
    lazy    => 1,
    default => sub {
      my $self = shift;
      $self->container->get('model.map_log');
    },
  );

  has 'history_log_model' => (
    is      => 'ro',
    isa     => 'Jikkoku::Model::HistoryLog',
    lazy    => 1,
    default => sub {
      my $self = shift;
      $self->container->get('model.history_log');
    },
  );

  has 'login_list_model' => (
    is      => 'ro',
    isa     => 'Jikkoku::Model::LoginList',
    lazy    => 1,
    default => sub {
      my $self = shift;
      $self->container->get('model.login_list');
    },
  );

  my $CONFIG = Jikkoku::Model::Config->get;

  sub root {
    my $self = shift;
    $self->game_record->increment_access_count;
    $self->game_record->save;
    $self->render('index.pl', +{
      announcements => $self->announce_model->get_all,
      game_conf     => $CONFIG->{game},
      game_date     => $self->game_date,
      game_record   => $self->game_record,
      map_logs      => $self->map_log_model->get(MAP_LOG_NUM),
      history_logs  => $self->history_log_model->get(HISTORY_LOG_NUM),
      login_list    => $self->login_list_model->get_all,
      cache_id      => $self->req->cookies->{cache_id} // '',
      cache_pass    => $self->req->cookies->{cache_pass} // '',
    });
  }

  __PACKAGE__->meta->make_immutable;

}

1;
