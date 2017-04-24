package Jikkoku::Model::Formation {

  use Mouse;
  use Jikkoku;
  use Jikkoku::Class::Formation;
  use Jikkoku::Model::Config;

  has 'get_all_formations' => (
    is      => 'ro',
    isa     => 'ArrayRef[Jikkoku::Class::Formation]',
    lazy    => 1,
    builder => '_build_data',
  );

  has 'name_dict' => (
    is      => 'ro',
    isa     => 'HashRef[Jikkoku::Class::Formation]',
    lazy    => 1,
    builder => '_build_name_dict',
  );

  sub _build_data {
    my $self = shift;
    my $formations_data = Jikkoku::Model::Config->get->{formation};
    [ map { $self->generate_treat_class($_) } @$formations_data ];
  }

  sub generate_treat_class {
    my ($self, $args) = @_;
    Jikkoku::Class::Formation->new(
      %$args,
      formation_model => $self,
    );
  }

  sub _build_name_dict {
    my $self = shift;
    +{ map { $_->name => $_ } @{ $self->get_all_formations } };
  }

  sub get_formation {
    my ($self, $id) = @_;
    Carp::croak 'few arguments (id)' if @_ < 2;
    $self->get_all_formations->[$id] // Carp::confess "id : $id の陣形データは見つかりませんでした";
  }

  sub get_formation_by_name {
    my ($self, $name) = @_;
    Carp::croak 'few arguments (name)' if @_ < 2;
    $self->name_dict->{$name} // Carp::confess "name : $name の陣形データは見つかりませんでした";
  }

  __PACKAGE__->meta->make_immutable;

}

1;

