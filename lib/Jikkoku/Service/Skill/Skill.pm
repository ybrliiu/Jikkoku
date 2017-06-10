package Jikkoku::Service::Skill::Skill {

  use Mouse::Role;
  use Jikkoku;

  has 'chara' => (
    is       => 'ro',
    isa      => 'Jikkoku::Class::Chara',
    required => 1,
  );

  has 'skill' => (
    is      => 'ro',
    does    => 'Jikkoku::Class::Skill::Skill',
    lazy    => 1,
    default => sub {
      my $self = shift;
      my ($category, $id) = (split /::/, ref $self)[-2, -1];
      $self->chara->skills->get({
        category => $category,
        id       => $id,
      });
    },
  );

}

1;

