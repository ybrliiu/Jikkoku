package Jikkoku::Model::Soldier {

  use Mouse;
  use Jikkoku;

  use Jikkoku::Model::Config;
  use Jikkoku::Class::Soldier;
  use Jikkoku::Class::Chara::Soldier;

  has 'data' => (
    is      => 'ro',
    isa     => 'ArrayRef[Jikkoku::Class::Soldier]',
    lazy    => 1,
    builder => '_build_data',
  );

  has 'name_map' => (
    is      => 'ro',
    isa     => 'HashRef[Jikkoku::Class::Soldier]',
    lazy    => 1,
    builder => '_build_name_map',
  );

  with 'Jikkoku::Role::Singleton';

  sub _build_data {
    my $self = shift;
    my $soldiers_data = Jikkoku::Model::Config->get->{soldier};
    [ map { $self->create_treat_class($_) } @$soldiers_data ];
  }

  sub _build_name_map {
    my $self = shift;
    +{ map { $_->name => $_ } @{ $self->get_all } };
  }

  __PACKAGE__->meta->add_method(get_all => \&data);

  sub create_treat_class {
    my ($self, $args) = @_;
    Jikkoku::Class::Soldier->new($args);
  }

  sub get {
    my ($self, $id) = @_;
    Carp::croak 'few arguments (id)' if @_ < 2;
    $self->data->[$id] // Carp::confess "id : $id の兵士データは見つかりませんでした";
  }

  sub get_by_name {
    my ($self, $name) = @_;
    Carp::croak 'few arguments (name)' if @_ < 2;
    $self->name_map->{$name} // Carp::confess "name : $name の兵士データは見つかりませんでした";
  }

}

1;
