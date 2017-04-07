package Jikkoku::Class::State::Role::Given {

  use Mouse::Role;
  use Jikkoku;

  around state_data_keys => sub {
    my ($orig, $self) = @_;
    [ @{ $self->$orig() }, 'giver_id' ];
  };

  sub giver_id {
    my $self = shift;
    $self->chara->states_data->get_with_option($self->id)->match(
      Some => sub { $_->{giver_id} },
      None => sub { Carp::confess $self->name . 'にかかっていません' },
    );
  }

}

1;

