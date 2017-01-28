package Jikkoku::Class::BattleMap::Node::Role::Castle {

  use Moo::Role;
  use Carp;
  use Jikkoku;

  has 'town_name' => ( is => 'rw' );
  has 'town_wall' => ( is => 'rw' );

  after BUILD => sub {
    my $self = shift;
    Carp::croak "城地形ではありません" unless $self->is_castle;
  };

  sub set_town_info {
    my ($self, $town) = @_;
    Carp::croak "引数が足りません" if @_ < 2;
    $self->town_wall( $town->wall );
    $self->town_name( $town->name );
  }

  around name => sub {
    my ($orig, $self) = @_;
    $self->town_name
      ? $self->town_name . $self->$orig() . '<br>城壁 : ' . $self->town_wall
      : $self->$orig();
  };

}

1;
