package Jikkoku::Model::Skill {

  use Mouse;
  use Jikkoku;
  use Jikkoku::Util qw( validate_values );

  use constant {
    NAMESPACE => 'Jikkoku::Class::Skill',
    ROLE      => 'Jikkoku::Class::Skill::Skill',
  };

  has 'chara' => ( is => 'ro', isa => 'Jikkoku::Class::Chara::ExtChara', weak_ref => 1, required => 1 );

  with 'Jikkoku::Model::Role::Class';

  sub skill_key {
    my ($class, $args) = @_;
    "$args->{category}::$args->{id}";
  }

  sub get {
    my ($self, $args) = @_;
    validate_values $args => [qw/ category id /];
    my $key = $self->skill_key($args);
    "Jikkoku::Class::Skill::${key}"->new(chara => $self->chara);
  }

  around get_all => sub {
    my ($orig, $self) = @_;
    [
      map {
        my ($category, $id) = split /::/, $_;
        $self->get({
          id       => $id,
          category => $category,
        })
      } @{ $self->MODULES }
    ];
  };

  __PACKAGE__->prepare;
  __PACKAGE__->meta->make_immutable;

}

package Jikkoku::Model::Skill::Result {

  use Mouse;
  use Jikkoku;
  use Jikkoku::Util qw( validate_values );

  with 'Jikkoku::Model::Role::Result';

  has 'key_map' => (
    is      => 'ro',
    isa     => 'HashRef[Jikkoku::Class::Skill::Skill]',
    lazy    => 1,
    default => sub {
      my $self = shift;
      +{
        map {
          my $key = Jikkoku::Model::Skill->skill_key({
            id       => $_->id,
            category => $_->category,
          });
          $key => $_;
        } @{ $self->data }
      };
    },
  );

  sub get {
    my ($self, $args) = @_;
    validate_values $args => [qw/ category id /];
    my $key = Jikkoku::Model::Skill->skill_key($args);
    $self->key_map->{$key} // Carp::croak "no such skill($key)";
  }

  sub get_next_skills {
    my ($self, $skill) = @_;
    Carp::croak 'Too few arguments' if @_ < 2;
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

  sub get_acquired_skills_with_result {
    my $self = shift;
    $self->create_result([ grep { $_->is_acquired } @{ $self->data } ]);
  }

  sub get_available_skills_with_result {
    my $self = shift;
    $self->create_result([ grep { $_->is_available } @{ $self->data } ]);
  }

  sub get_soldier_max_move_point_adjuster_skills_with_result {
    my $self = shift;
    $self->create_result([
      grep { $_->DOES('Jikkoku::Class::Chara::Soldier::MaxMovePointAdjuster') }
        @{ $self->data }
    ]);
  }

  sub get_soldier_charge_move_point_time_adjuster_skills_with_result {
    my $self = shift;
    $self->create_result([
      grep { $_->DOES('Jikkoku::Class::Chara::Soldier::ChargeMovePointAdjuster') }
        @{ $self->data }
    ]);
  }

  sub get_chara_power_adjuster_skills_with_result {
    my $self = shift;
    $self->create_result([
      grep { $_->DOES('Jikkoku::Service::BattleCommand::Battle::CharaPower::CharaPowerAdjuster') }
        @{ $self->data }
    ]);
  }

  sub get_enemy_power_adjuster_skills_with_result {
    my $self = shift;
    $self->create_result([
      grep { $_->DOES('Jikkoku::Service::BattleCommand::Battle::CharaPower::EnemyPowerAdjuster') } 
        @{ $self->data }
    ]);
  }

  sub get_battle_turn_adjuster_skills_with_result {
    my $self = shift;
    $self->create_result([
      grep { $_->DOES('Jikkoku::Service::BattleCommand::Battle::TurnAdjuster') }
        @{ $self->data }
    ]);
  }

  sub get_battle_event_executer_skills_with_result {
    my $self = shift;
    $self->create_result([
      grep { $_->DOES('Jikkoku::Service::BattleCommand::Battle::BattleLoop::EventExecuter') }
        @{ $self->data }
    ]);
  }

  __PACKAGE__->meta->make_immutable;

};

1;

