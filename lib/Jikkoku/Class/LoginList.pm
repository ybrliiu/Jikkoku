package Jikkoku::Class::LoginList {

  use Mouse;
  use Jikkoku;

  has 'time'       => ( metaclass => 'Column', is => 'ro', isa => 'Int', required => 1 );
  has 'name'       => ( metaclass => 'Column', is => 'ro', isa => 'Str', required => 1 );
  has 'country_id' => ( metaclass => 'Column', is => 'ro', isa => 'Int', required => 1 );
  has 'town_id'    => ( metaclass => 'Column', is => 'ro', isa => 'Int', required => 1 );

  with 'Jikkoku::Class::Role::TextData';

  sub show {
    my ($self, $town_model) = @_;
    $self->name. '[' . $town_model->get( $self->town_id )->name . ']';
  }

  __PACKAGE__->meta->make_immutable;
}

1;
