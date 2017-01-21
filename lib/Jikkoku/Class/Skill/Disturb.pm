package Jikkoku::Class::Skill::Disturb {

  use Jikkoku;

  sub new {
    my ($class, $chara) = @_;
    my $self = bless {
      name         => '妨害',
      belong_skill => {}
    }, $class;
    $self->{root_skill} = '';
    $self;
  }

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
