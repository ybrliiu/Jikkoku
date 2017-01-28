package Jikkoku::Class::Skill::Disturb {

  use Moo;
  use Jikkoku;

  has 'nme'          => (is => 'ro', default => '妨害');
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

  sub grep {
    my ($self, $code) = @_;
    my @stack;
    for my $skill ( values %{ $self->{belong_skill} } ) {
      push $skill if $code->($skill);
    }
    \@stack;
  }

}

1;
