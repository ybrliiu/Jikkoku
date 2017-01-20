package Jikkoku::Class::BattleMap::Node::Role::Castle {

  use Jikkoku;
  use Class::Accessor::Lite new => 0;
  use Role::Tiny;

  use Carp;

  {
    my %attributes = (
      town_name => undef,
      town_wall => undef,
    );

    Class::Accessor::Lite->mk_accessors(keys %attributes);

    around new => sub {
      my ($orig, $class, $args) = @_;
      my $self = $class->$orig($args);
      Carp::croak "城地形ではありません" unless $self->is_castle;
      $self->{$_} = $attributes{$_} for keys %attributes;
      $self;
    };
  }

  sub set_town_info {
    my ($self, $town) = @_;
    Carp::croak "引数が足りません" if @_ < 2;
    $self->{town_wall} = $town->wall;
    $self->{town_name} = $town->name;
  }

  around name => sub {
    my ($orig, $self) = @_;
    $self->{town_name}
      ? "$self->{town_name}@{[ $self->$orig() ]}<br>城壁 : $self->{town_wall}"
      : $self->$orig();
  };

}

1;
