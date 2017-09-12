package Jikkoku::Class::State::Role::Counter {

  use Mouse::Role;
  use Jikkoku;

  around state_data_keys => sub {
    my ($orig, $self) = @_;
    [ @{ $self->$orig() }, 'count' ];
  };

  around image_tag => sub {
    my ($orig, $self, $dir) = @_;
    $self->$orig($dir) . '+' . $self->count;
  };

  sub count {
    my $self = shift;
    $self->chara->states_data->get_with_option($self->id)->match(
      Some => sub { $_->{count} },
      None => sub { 0 },
    );
  }

  sub is_available {
    my $self = shift;
    $self->count > 0;
  }

}

1;

