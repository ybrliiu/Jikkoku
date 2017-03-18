package Jikkoku::Model::State {
  
  use Mouse;
  use Jikkoku;
  use Jikkoku::Util 'validate_values';
  use Module::Load 'load';

  our @STATE_MODULES = _get_state_module_list();

  sub _get_state_module_list {
    my $dir = './lib/Jikkoku/Class/State';
    opendir(my $dh, $dir);
    my @state_list = grep { $_ ne 'State' } map { $_ =~ /(\.pm$)/p ? ${^PREMATCH} : () } readdir $dh;
    close $dh;
    @state_list;
  }

  has 'chara'  => ( is => 'ro', isa => 'Jikkoku::Class::Chara', weak_ref => 1, required => 1 );
  has '_cache' => ( is => 'ro', isa => 'HashRef', default => sub { +{} } );

  sub get_state_with_option {
    my ($self, $args) = @_;
    validate_values $args => [qw/ id /];

    my $key = $args->{id};
    my $load_class = "Jikkoku::Class::State::${key}";
    state $loaded_class = {};
    unless (exists $loaded_class->{$key}) {
      eval {
        load $load_class;
        $loaded_class->{$key} = 1;
      };
      if (my $e = $@) {
        return Option::None->new;
      }
    }

    my $state = eval {
      $load_class->new(chara => $self->chara);
    };
    Option->new( $loaded_class->{$key} );
  }

  sub get {
    my ($self, $id) = @_;
    my $load_class = "Jikkoku::Class::State::${id}";
    load $load_class;
    $load_class->new(chara => $self->chara);
  }

  sub get_all_state {
    my $self = shift;
    [ map { $self->get($_) } @STATE_MODULES ];
  }

  sub get_available_states {
    my ($self, $time) = @_;
    $time //= time;
    [
      grep { $_->is_available($time) }
      grep { $_->DOES('Jikkoku::Class::State::Role::Expires') } @{ $self->get_all_state }
    ];
  }

  sub available_list {
    my $self = shift;
    [ grep { $_->is_in_the_state } values %{ $self->{states} } ];
  }

  __PACKAGE__->meta->make_immutable;

}

1;

