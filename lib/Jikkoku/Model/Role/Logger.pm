package Jikkoku::Model::Role::Logger {

  use Mouse::Role;
  use Jikkoku;

  with 'Jikkoku::Model::Role::List';

  around add => sub {
    my ($self, $str) = @_;
    Carp::croak 'few arguments($str)' if @_ < 2;
    unshift @{ $self->data }, "$str (@{[ Jikkoku::Util::daytime ]})\n";
    $self;
  };

}

1;

