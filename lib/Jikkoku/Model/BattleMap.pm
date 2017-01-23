package Jikkoku::Model::BattleMap {

  use Jikkoku;

  use Jikkoku::Class::BattleMap;

  use constant {
    CLASS    => 'Jikkoku::Class::BattleMap',
    DIR_PATH => 'etc/battle_map_data/',
  };
  
  sub new {
    my ($class) = @_;
    state $singleton = bless {data => {}}, $class;
  }

  sub get {
    my ($self, $map_id) = @_;
    return $self->{data}{$map_id} if exists $self->{data}{$map_id};
    $self->load( $map_id );
  }

  sub load {
    my ($self, $map_id) = @_;
    my $map_data = require( DIR_PATH . "$map_id.pl" );
    $self->{data} = +{
      %{ $self->{data} },
      %$map_data,
    };
    $self->{data}{$map_id} = Jikkoku::Class::BattleMap->new( $self->{data}{$map_id} );
  }

}

1;
