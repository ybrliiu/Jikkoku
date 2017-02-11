package Jikkoku::Class::Skill::SkillCategory {

  use Mouse::Role;
  use Jikkoku;
  use Jikkoku::Util;

  requires qw( name root_skill_class );

  has 'chara'        => ( is => 'ro', isa => 'Jikkoku::Class::Chara', weak_ref => 1 );
  has 'belong_skill' => ( is => 'rw', isa => 'HashRef', lazy => 1, builder => '_build_belong_skill' );

  sub _build_belong_skill {
    my $self = shift;
    my $class = ref $self;
    my $skill_list = Jikkoku::Util::load_child($class);
  }

  sub get {
    my ($self, $name) = @_;
    $self->belong_skill->{$name};
  }

  sub trace {
    my $self = shift;
    my $root_skill = $self->get($self->root_skill_class);
    _trace( @{ $root_skill->next_skill } );
  }

  sub _trace {
    my (@next_skill) = @_;
    for my $skill (@next_skill) {
      _trace( @{ $skill->next_skill } );
    }
  }

}

1;

