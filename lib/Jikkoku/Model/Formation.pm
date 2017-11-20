package Jikkoku::Model::Formation {

  use Mouse;
  use Jikkoku;

  use constant {
    INFLATE_TO       => 'Formation',
    CONFIG_FILE_NAME => 'formation',
  };

  with 'Jikkoku::Model::Role::ConfigToObject';

  sub create_treat_class {
    my ($self, $args) = @_;
    $self->class( $self->INFLATE_TO )->new(
      %$args,
      formation_model => $self,
    );
  }

  sub get_available_formations {
    my ($self, $chara) = @_;
    Carp::croak 'Too few arguments (required: $chara)' if @_ < 2;
    [ grep { $_->is_available($chara) } @{ $self->get_all } ];
  }

  __PACKAGE__->meta->make_immutable;

}

1;

