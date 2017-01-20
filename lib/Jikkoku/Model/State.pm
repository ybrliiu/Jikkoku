package Jikkoku::Model::State {
  
  use Jikkoku;
  use Carp qw/croak/;
  use Scalar::Util qw/weaken/;
  use Jikkoku::Util qw/load_child/;

  my $parent_class = 'Jikkoku::Class::State';
  my $state_module_list = load_child $parent_class;

  sub new {
    my ($class, $chara) = @_;
    croak "引数が足りません" if @_ < 2;
    my $self = bless {
      chara  => $chara,
      states => {},
    }, $class;
    weaken $self->{chara};
    for my $klass (@$state_module_list) {
      my $state = $klass->new({chara => $chara});
      $self->{states}{ $klass =~ s/${parent_class}:://r } = $state;
    }
    $self;
  }

  sub get {
    my ($self, $name) = @_;
    $self->{states}{$name};
  }

  sub available_list {
    my $self = shift;
    [ grep { $_->is_in_the_state } values %{ $self->{states} } ];
  }

}

1;

