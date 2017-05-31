package Jikkoku::Model::Formation {

  use Mouse;
  use Jikkoku;
  use Jikkoku::Class::Formation;
  use Jikkoku::Model::Config;

  has 'data' => (
    is      => 'ro',
    isa     => 'ArrayRef[Jikkoku::Class::Formation]',
    lazy    => 1,
    builder => '_build_data',
  );

  has 'name_map' => (
    is      => 'ro',
    isa     => 'HashRef[Jikkoku::Class::Formation]',
    lazy    => 1,
    builder => '_build_name_map',
  );

  with 'Jikkoku::Role::Singleton';

  sub _build_data {
    my $self = shift;
    my $formations_data = Jikkoku::Model::Config->get->{formation};
    [ map { $self->create_treat_class($_) } @$formations_data ];
  }

  sub _build_name_map {
    my $self = shift;
    +{ map { $_->name => $_ } @{ $self->get_all } };
  }

  __PACKAGE__->meta->add_method(get_all => \&data);

  sub create_treat_class {
    my ($self, $args) = @_;
    Jikkoku::Class::Formation->new(
      %$args,
      formation_model => $self,
    );
  }

  sub get {
    my ($self, $id) = @_;
    Carp::croak 'few arguments (id)' if @_ < 2;
    $self->data->[$id] // Carp::confess "id : $id の陣形データは見つかりませんでした";
  }

  sub get_by_name {
    my ($self, $name) = @_;
    Carp::croak 'few arguments (name)' if @_ < 2;
    $self->name_map->{$name} // Carp::confess "name : $name の陣形データは見つかりませんでした";
  }

  sub get_available_formations {
    my ($self, $chara) = @_;
    Carp::croak 'few arguments($chara)' if @_ < 2;
    [ grep { $_->is_available($chara) } @{ $self->get_all } ];
  }

  __PACKAGE__->meta->make_immutable;

}

1;

