package Jikkoku::Class::Skill::Disturb {

  use Mouse;
  use Jikkoku;

  has 'name'         => (is => 'ro', default => '妨害');
  has 'belong_skill' => (is => 'rw', default => sub { {} });
  has 'root_skill'   => (is => 'ro', default => '');

  sub get {
    my ($self, $name) = @_;
    $self->{belong_skill}{$name};
  }

  sub trace {
    my $self = shift;
    _trace( @{ $self->{root_skill}->next_skill } );
  }

  sub _trace {
    my (@next_skill) = @_;
    for my $skill (@next_skill) {
      _trace( @{ $skill->next_skill } );
    }
  }

}

1;
