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
