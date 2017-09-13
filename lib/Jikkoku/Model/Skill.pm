package Jikkoku::Model::Skill {

  use Mouse;
  use Jikkoku;

  use Carp;
  use Option;
  use List::Util qw( sum );
  use Module::Load 'load';
  use Jikkoku::Util 'validate_values';

  our @SKILL_MODULES = _get_skill_module_list();

  sub _get_skill_module_list {
    my $dir = './lib/Jikkoku/Class/Skill';
    opendir(my $dh, $dir);
    my @dir_list = grep { $_ ne 'Role' && $_ !~ /(\.pm$)|(\.)/ } readdir $dh;
    close $dh;
    my @modules = map {
      my $dir_name = $_;
      opendir(my $dh, "${dir}/${dir_name}");
      my @modules =  map {
        +{
          category => $dir_name,
          id       => $_,
        };
      } map {
        $_ =~ /(\.pm$)/p ? ${^PREMATCH} : ()
      } readdir $dh;
      close $dh;
      @modules;
    } @dir_list;
    @modules;
  }

  has 'chara'  => ( is => 'ro', isa => 'Jikkoku::Class::Chara::ExtChara', weak_ref => 1, required => 1 );
  has '_cache' => ( is => 'ro', isa => 'HashRef', default => sub { +{} } );

  sub skill_key {
    my ($self, $args) = @_;
    "$args->{category}::$args->{id}";
  }

  sub get {
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
    exists $self->_cache->{$key} ? $self->_cache->{$key} : $self->get($args);
  }

  sub get_next_skills {
    my ($self, $skill) = @_;
    Carp::croak 'few arguments' if @_ < 2;
    [
      map {
        my $next_skill_id = $_;
        $self->get({
          id       => $next_skill_id,
          category => $skill->category,
        });
      } @{ $skill->next_skills_id }
    ];
  }

  sub get_all {
    my $self = shift;
    [ map { $self->get($_) } @SKILL_MODULES ];
  }

  sub get_acquired_skills {
    my $self = shift;
    [ grep { $_->is_acquired } @{ $self->get_all } ];
  }

  sub adjust_soldier_max_move_point {
    my ($self, $orig_cost) = @_;
    Carp::croak 'few arguments' if @_ < 2;
    my @skills = grep {
      $_->DOES('Jikkoku::Class::Chara::Soldier::MaxMovePointAdjuster')
    } @{ $self->get_acquired_skills };
    sum map { $_->adjust_soldier_max_move_point } @skills;
  }

  sub adjust_soldier_charge_move_point_time {
    my ($self, $charge_time) = @_;
    Carp::croak 'few arguments' if @_ < 2;
    my @skills = grep {
      $_->DOES('Jikkoku::Class::Chara::Soldier::ChargeMovePointAdjuster')
    } @{ $self->get_acquired_skills };
    sum map { $_->adjust_soldier_charge_move_point_time } @skills;
  }

  __PACKAGE__->meta->make_immutable;

}

1;

