package Jikkoku::Class::State::Role::Expires {

  use Mouse::Role;
  use Jikkoku;

  around state_data_keys => sub {
    my ($orig, $self) = @_;
    [ @{ $self->$orig() }, 'available_time' ];
  };

  sub available_time {
    my $self = shift;
    $self->chara->states_data->get_with_option($self->id)->match(
      Some => sub { $_->{available_time} },
      None => sub { 0 },
    );
  }

  sub is_available {
    my ($self, $time) = @_;
    $time //= time;
    $self->available_time >= $time;
  }

}

1;

