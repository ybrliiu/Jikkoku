package Jikkoku::Model::SkillCategory {

  use Mouse;
  use Jikkoku;
  use Jikkoku::Util qw( validate_values );

  use constant {
    ROLE      => 'Jikkoku::Class::Skill::SkillCategory',
    NAMESPACE => 'Jikkoku::Class::Skill',
  };

  has 'skills' => ( is => 'ro', isa => 'Jikkoku::Model::Skill::Result', required => 1 );

  with 'Jikkoku::Model::Role::Class';

  sub get {
    my ($self, $id) = @_;
    Carp::croak 'few arguments($id)' if @_ < 2;
    "Jikkoku::Class::Skill::${id}"->new(skills => $self->skills);
  }

  __PACKAGE__->prepare;
  __PACKAGE__->meta->make_immutable;

}

package Jikkoku::Model::SkillCategory::Result {

  use Mouse;
  use Jikkoku;

  has 'id_map' => (
    is      => 'ro',
    isa     => 'HashRef[Jikkoku::Class::Skill::SkillCategory]',
    lazy    => 1,
    default => sub {
      my $self = shift;
      +{ map { $_->id => $_ } @{ $self->data } };
    },
  );

  with 'Jikkoku::Model::Role::Result';

  sub get {
    my ($self, $id) = @_;
    Carp::croak 'few arguments($id)' if @_ < 2;
    $self->id_map->{$id} // Carp::croak "no such skill_category($id)";
  }

  __PACKAGE__->meta->make_immutable;

}

1;

