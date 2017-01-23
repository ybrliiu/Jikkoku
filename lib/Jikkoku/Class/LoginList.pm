package Jikkoku::Class::LoginList {

  use Jikkoku;
  use parent 'Jikkoku::Class::Base::TextData';

  use constant {
    PRIMARY_KEY => 'name',
    COLUMNS     => [qw/
      time name country_id town_id
    /],
  };

  sub show {
    my ($self, $town_model) = @_;
    $self->{name}. '[' . $town_model->get( $self->{town_id} )->name . ']';
  }

  __PACKAGE__->make_accessors( COLUMNS );
}

1;
