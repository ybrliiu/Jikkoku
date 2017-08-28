package Jikkoku::Model::Role::Integration::Expires {

  use Mouse::Role;
  use Jikkoku;

  # constants
  requires qw( EXPIRE_TIME );

  sub BUILD {
    my $self = shift;
    $self->update;
  }

  sub update {
    my $self = shift;
    my $time = time;
    my $pattr = $self->PRIMARY_ATTRIBUTE;
    for my $obj (@{ $self->get_all }) {
      $self->delete($obj->$pattr) if $obj->time < $time;
    }
    $self->save;
  }

}

1;

