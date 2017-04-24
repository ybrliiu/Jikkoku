package Jikkoku::Model::Skill {

  use Mouse;
  use Jikkoku;

  use Carp;
  use Option;
  use Module::Load 'load';
  use Jikkoku::Util 'validate_values';

  has 'chara'  => ( is => 'ro', isa => 'Jikkoku::Class::Chara', weak_ref => 1, required => 1 );
  has '_cache' => ( is => 'ro', isa => 'HashRef', default => sub { +{} } );

  sub skill_key {
    my ($self, $args) = @_;
    "$args->{category}::$args->{id}";
  }

  sub get_skill {
    my ($self, $args) = @_;
    validate_values $args => [qw/ category id /];

    my $key = $self->skill_key($args);
    my $load_class = "Jikkoku::Class::Skill::${key}";
    state $loaded_class = {};
    unless (exists $loaded_class->{$key}) {
      Module::Load::load $load_class;
      $loaded_class->{$key} = 1;
    }

    $self->_cache->{$key} = $load_class->new(chara => $self->chara);
  }

  sub get_chached_skill {
    my ($self, $args) = @_;
    validate_values $args => [qw/ category id /];
    my $key = $self->skill_key($args);
    exists $self->_cache->{$key} ? $self->_cache->{$key} : $self->get_skill($args);
  }

  sub get_skill_with_option {
    my ($self, $args) = @_;
    validate_values $args => [qw/ category id /];

    my $key = $self->skill_key($args);
    my $load_class = "Jikkoku::Class::Skill::${key}";
    state $loaded_class = {};
    unless (exists $loaded_class->{$key}) {
      eval {
        Module::Load::load $load_class;
        $loaded_class->{$key} = 1;
      };
      if (my $e = $@) {
        return Option::None->new;
      }
    }

    $self->_cache->{$key} = eval {
      $load_class->new(chara => $self->chara);
    };
    if (my $e = $@) {
      return Option::None->new;
    }

    Option->new($self->_cache->{$key});
  }

  sub get_chached_skill_with_option {
    my ($self, $args) = @_;
    validate_values $args => [qw/ category id /];
    
    my $key = $self->skill_key($args);
    exists $self->_cache->{$key} ?
      Option->new($self->_cache->{$key}) : $self->get_skill_with_option($args);
  }

  sub get_next_skills {
    my ($self, $skill) = @_;
    Carp::croak 'few arguments' if @_ < 2;
    [ map {
      my $next_skill_id = $_;
      $self->get_skill_with_option({
        id       => $next_skill_id,
        category => $skill->category,
      })->match(
        Some => sub { $_ },
        None => sub { Carp::confess $skill->name . 'の next_skill の定義が異常です' },
      );
    } @{ $skill->next_skills_id } ];
  }

  __PACKAGE__->meta->make_immutable;

}

1;

