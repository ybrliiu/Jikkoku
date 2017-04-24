package Jikkoku::Model::Soldier {

  use Jikkoku;
  use Carp;

  use constant {
    FILE_PATH => './etc/soldier.conf',
  };

  sub new {
    my ($class) = @_;
    state $self;
    return $self if defined $self;
    my $soldier_data = do( FILE_PATH() );
    $self = bless $soldier_data, $class;
  }

  sub get {
    my ($self, $soldier_id) = @_;
    Carp::croak 'few argments($soldier_id)' if @_ < 2;
    $self->[$soldier_id];
  }

}

1;
