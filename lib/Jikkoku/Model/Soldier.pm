package Jikkoku::Model::Soldier {

  use v5.14;
  use warnings;

  use constant {
    FILE_PATH => 'etc/soldier.conf',
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
    $self->[$soldier_id];
  }

}

1;
