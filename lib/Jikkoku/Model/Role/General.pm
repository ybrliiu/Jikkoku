package Jikkoku::Model::Role::General {

  use Mouse::Role;
  use Jikkoku;
  use Option ();

  has 'data' => ( is => 'rw', isa => 'HashRef', required => 1 );

  with 'Jikkoku::Model::Role::Base';

  sub get {
    my ($self, $primary_attribute_value) = @_;
    Carp::croak 'Too few arguments (required: $primary_attribute_value)' if @_ < 2;
    $self->data->{$primary_attribute_value} // Carp::confess "no such data($primary_attribute_value)";
  }

  sub get_with_option {
    my ($self, $primary_attribute_value) = @_;
    Carp::croak 'Too few arguments (required: $primary_attribute_value)' if @_ < 2;
    Option::option( $self->data->{$primary_attribute_value} );
  }

  sub get_all {
    my $self = shift;
    my $primary_attribute = $self->PRIMARY_ATTRIBUTE;
    [ sort { $a->$primary_attribute cmp $b->$primary_attribute } values %{ $self->data } ];
  }

  sub create {
    my ($self, $obj) = @_;
    Carp::croak 'Too few arguments (required: $obj)' if @_ < 2;
    Carp::croak '$obj type is invalid type' unless $obj->isa($self->INFLATE_TO);
    my $primary_attribute = $self->PRIMARY_ATTRIBUTE;
    $self->data->{ $obj->$primary_attribute } = $obj;
  }

  sub delete : method {
    my ($self, $primary_attribute_value) = @_;
    Carp::croak 'Too few arguments (required: $primary_attribute_value)' if @_ < 2;
    delete $self->data->{$primary_attribute_value};
  }

}

1;

