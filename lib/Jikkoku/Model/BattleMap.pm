package Jikkoku::Model::BattleMap {

  use Jikkoku;
  use Option;
  use Jikkoku::Util 'validate_values';
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

  *get_battle_map = \&get;

  sub get_with_option {
    my ($self, $map_id) = @_;
    return $self->{data}{$map_id} if exists $self->{data}{$map_id};
    option $self->load( $map_id );
  }

  sub get_between_town_battle_map {
    my ($self, $args) = @_;
    validate_values $args => [qw/ start_town_id target_town_id /];
    my $map_data = eval {
      $self->get("$args->{start_town_id}-$args->{target_town_id}");
    };
    if (my $e = $@) {
      $map_data = eval {
        $self->get("$args->{target_town_id}-$args->{start_town_id}");
      };
      if (my $e = $@) {
        Carp::croak "マップデータが見つかりませんでした"
          . "( start_town_id => $args->{start_town_id}, target_town_id => $args->{target_town_id} )";
      }
    }
    $map_data;
  }

  sub load {
    my ($self, $map_id) = @_;
    my $map_data = eval { require( DIR_PATH . "$map_id.pl" ) };
    if (my $e = $@) {
      Carp::confess($e);
    }
    $self->{data} = +{
      %{ $self->{data} },
      %$map_data,
    };
    $self->{data}{$map_id} = Jikkoku::Class::BattleMap->new( $self->{data}{$map_id} );
  }

}

1;
