package Jikkoku::Class::Chara::Profile {

  use Mouse;
  use Jikkoku;
  
  use constant {
    MAX      => 1,
    DIR_PATH => 'charalog/prof/',
  };

  with 'Jikkoku::Class::Role::Logger::Division';

  around get => sub {
    my ($orig, $self) = @_;
    $self->data->[0];
  };

  sub edit {
    my ($self, $message) = @_;
    Carp::croak 'Too few arguments (required: $message)' if @_ < 2;
    $self->data->[0] = $message;
  }

  __PACKAGE__->meta->make_immutable;

}

1;

