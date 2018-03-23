package Test::Jikkoku::Container {

  use Jikkoku;
  use Mouse;

  has 'container' => ( is => 'ro', isa => 'HashRef', default => sub { +{} } );
  has 'cache'     => ( is => 'ro', isa => 'HashRef', default => sub { +{} } );

  with qw(
    Jikkoku::Role::Loader
    Jikkoku::Role::Singleton
  );

  sub BUILD {
    my $self = shift;
    my $container = $self->container;

    $container->{'model.chara'} = sub { $self->model('Chara')->new };
    $container->{'model.battle_map'} = sub { $self->model('BattleMap')->new };

    $container->{'service.battle_command.battle.battle_loop'} = sub {
      my $self = shift;
      $self->service('BattleCommand::Battle::BattleLoop')->new({
        chara        => $self->get('test.battle_chara'),
        target       => $self->get('test.battle_enemy'),
        chara_power  => $self->get('test.chara_power'),
        target_power => $self->get('test.enemy_power'),
        is_siege     => $self->create('service.battle_command.battle.is_siege'),
        distance     => 1,
        end_turn     => 10,
      });
    };

    $container->{'service.battle_command.battle.is_siege'} = 0;

    $container->{'test.chara_id'} = 'haruka';
    $container->{'test.chara'} = sub {
      $self->get('model.chara')
        ->get($self->get('test.chara_id'))
    };
    $container->{'test.ext_chara'} = sub {
      $self->class('Chara::ExtChara')->new(chara => $self->get('test.chara'))
    };
    $container->{'test.battle_chara'} = sub {
      $self->service('BattleCommand::Battle::Chara')
        ->new(chara => $self->get('test.chara'))
    };
    $container->{'test.chara_power'} = sub {
      $self->service('BattleCommand::Battle::CharaPower::CharaPower')
        ->new({
          chara    => $self->get('test.battle_chara'),
          target   => $self->get('test.battle_enemy'),
          is_siege => $self->get('service.battle_command.battle.is_siege'),
        });
    };

    $container->{'test.enemy_id'} = 'mituki';
    $container->{'test.enemy'} = sub {
      $self->get('model.chara')
        ->get($self->get('test.enemy_id'))
    };
    $container->{'test.ext_enemy'} = sub {
      $self->class('Chara::ExtChara')->new(chara => $self->get('test.enemy'));
    };
    $container->{'test.battle_enemy'} = sub {
      $self->service('BattleCommand::Battle::Chara')
        ->new(chara => $self->get('test.enemy'));
    };
    $container->{'test.enemy_power'} = sub {
      $self->service('BattleCommand::Battle::CharaPower::CharaPower')
        ->new({
          chara    => $self->get('test.battle_enemy'),
          target   => $self->get('test.battle_chara'),
          is_siege => $self->get('service.battle_command.battle.is_siege'),
        });
    };

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

