package Jikkoku::Container {

  use Jikkoku;
  use Mouse;

  has 'cache'     => ( is => 'ro', isa => 'HashRef', default => sub { +{} } );
  has 'container' => ( is => 'ro', isa => 'HashRef', default => sub { +{} } );

  with qw(
    Jikkoku::Role::Loader
    Jikkoku::Role::Singleton
  );

  sub BUILD {
    my $self = shift;
    my $container = $self->container;

    $container->{'common.game_date'} = sub { $self->model('GameDate')->new->get };
    $container->{'common.game_record'} = sub { $self->model('GameRecord')->new->get };

    $container->{'model.chara'} = sub { $self->model('Chara')->new };
    $container->{'model.map_log'} = sub { $self->model('MapLog')->new };
    $container->{'model.history_log'} = sub { $self->model('HistoryLog')->new };
    $container->{'model.login_list'} = sub { $self->model('LoginList')->new };
    $container->{'model.announce'} = sub { $self->model('Announce')->new };
    $container->{'model.battle_map'} = sub { $self->model('BattleMap')->new };

  }

  sub get {
    Carp::croak 'few arguments($key)' if @_ < 2;
    my ($self, $key) = @_;
    if (exists $self->cache->{$key}) {
      $self->cache->{$key};
    } else {
      $self->create($key);
    }
  }

  sub create {
    Carp::croak 'few arguments($key)' if @_ < 2;
    my ($self, $key) = @_;
    my $val = $self->container->{$key};
    Carp::croak "the value is not exist($key)" unless defined $val;
    $self->cache->{$key} = ref $val eq 'CODE' ? $self->$val() : $val;
  }

  sub set {
    my ($self, $key, $value) = @_;
    Carp::croak 'few arguments($key, $value)' if @_ < 3;
    $self->container->{$key} = $value;
  }

  __PACKAGE__->meta->make_immutable;

}

1;

