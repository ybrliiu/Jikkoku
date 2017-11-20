package Jikkoku::Model::Weapon::Attr {

  use Mouse;
  use Jikkoku;
  use Option;

  has 'attrs' => (
    is      => 'ro',
    isa     => 'ArrayRef',
    lazy    => 1,
    builder => '_build_attrs',
  );

  has 'name_map' => (
    is => 'ro',
    isa => 'HashRef',
    lazy => 1,
    default => sub {
      my $self = shift;
      +{ map { $_->name => $_ } @{ $self->attrs } };
    },
  );

  with qw(
    Jikkoku::Role::Loader
    Jikkoku::Role::Singleton
  );

  sub _build_attrs {
    my $self = shift;
    my $dir = './lib/Jikkoku/Class/Weapon/Attr';
    opendir(my $dh, $dir);
    my @attrs = map  { $_->new }
                grep { $_->can('new') }
                map  { $self->class("Weapon::Attr::$_") }
                map  { $_ =~ s/\.pm//gr }
                grep { $_ =~ /(\.pm$)/p ? ${^PREMATCH} : () } readdir $dh;
    close $dh;
    \@attrs;
  }

  sub get {
    my ($self, $name) = @_;
    Carp::croak 'few arguments($name)' if @_ < 2;
    $self->name_map->{$name} // Carp::croak "${name}という属性は見つかりませんでした";
  }

  sub get_with_option {
    my ($self, $name) = @_;
    Carp::croak 'few arguments($name)' if @_ < 2;
    option $self->name_map->{$name};
  }

  __PACKAGE__->meta->make_immutable;

}

1;

