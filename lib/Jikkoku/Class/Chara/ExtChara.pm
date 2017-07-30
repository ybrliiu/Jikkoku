package Jikkoku::Class::Chara::ExtChara {

  use Mouse;
  use Jikkoku;

  use Jikkoku::Class::Chara;

  {
    my @delegations = (
      ( map { $_->name } Jikkoku::Class::Chara->get_column_attributes ),
      qw/ commit lock save /,
    );

    has 'chara' => (
      is       => 'ro',
      isa      => 'Jikkoku::Class::Chara',
      handles  => \@delegations,
      required => 1,
    );
  }

  has 'soldier' => (
    is      => 'ro',
    isa     => 'Jikkoku::Class::Chara::Soldier',
    lazy    => 1,
    default => sub {
      my $self = shift;
      my $soldier_data = $self->load_model('Soldier')->instance->get( $self->_ability_exp->get('soldier_id') );
      $self->load_class('Chara::Soldier')->new( { %$soldier_data, chara => $self->chara } );
    },
  );

  has 'formation' => (
    is      => 'ro',
    isa     => 'Jikkoku::Class::Formation',
    lazy    => 1,
    default => sub {
      my $self = shift;
      $self->load_model('Formation')->instance->get( $self->_soldier_battle_map->get('formation_id') );
    },
  );

  has 'weapon' => (
    is      => 'ro',
    isa     => 'Jikkoku::Class::Chara::Weapon',
    lazy    => 1,
    default => sub {
      my $self = shift;
      $self->load_class('Chara::Weapon')->new( chara => $self->chara );
    },
  );

  has 'chara_battle_log_model' => (
    is      => 'ro',
    isa     => 'Jikkoku::Model::Chara::BattleLog',
    lazy    => 1,
    default => sub {
      my $self = shift;
      $self->load_model('Chara::BattleLog')->new;
    },
  );

  has 'battle_logger' => (
    is      => 'ro',
    isa     => 'Jikkoku::Class::Chara::BattleLog',
    lazy    => 1,
    default => sub {
      my $self = shift;
      $self->chara_battle_log_model->get( $self->id );
    },
  );

  has 'chara_command_log_model' => (
    is      => 'ro',
    isa     => 'Jikkoku::Model::Chara::CommandLog',
    lazy    => 1,
    default => sub {
      my $self = shift;
      $self->load_model('Chara::CommandLog')->new;
    },
  );

  has 'command_logger' => (
    is      => 'ro',
    isa     => 'Jikkoku::Class::Chara::CommandLog',
    lazy    => 1,
    default => sub {
      my $self = shift;
      $self->chara_command_log_model->get( $self->id );
    },
  );

  has 'country_model' => (
    is      => 'ro',
    isa     => 'Jikkoku::Model::Country',
    lazy    => 1,
    default => sub {
      my $self = shift;
      $self->load_model('Country')->new;
    },
  );

  has 'country' => (
    is      => 'ro',
    isa     => 'Jikkoku::Class::Country',
    lazy    => 1,
    default => sub {
      my $self = shift;
      $self->country_model->get_with_option( $self->chara->country_id )->match(
        Some => sub { $_ },
        None => sub { $self->country_model->neutral },
      );
    },
  );

  has 'town_model' => (
    is      => 'ro',
    isa     => 'Jikkoku::Model::Town',
    lazy    => 1,
    default => sub {
      my $self = shift;
      $self->load_model('Town')->new;
    },
  );

  has 'is_invasion' => (
    is      => 'ro',
    isa     => 'Bool',
    lazy    => 1,
    default => sub {
      my $self = shift;
      $self->load_service('Chara::Soldier::JudgeInvasionOrDefence')->new({
        chara         => $self->chara,
        chara_soldier => $self->soldier,
        town_model    => $self->town_model,
      })->is_invasion();
    },
  );

  has 'states' => (
    is      => 'ro',
    isa     => 'Jikkoku::Model::State',
    lazy    => 1,
    default => sub {
      my $self = shift;
      $self->load_model('State')->new( chara => $self->chara )
    },
  );

  has 'skills' => (
    is      => 'ro',
    isa     => 'Jikkoku::Model::Skill',
    lazy    => 1,
    default => sub {
      my $self = shift;
      $self->load_model('Skill')->new( chara => $self->chara )
    },
  );

  has 'extensive_states' => (
    is      => 'ro',
    isa     => 'Jikkoku::Model::ExtensiveState',
    lazy    => 1,
    default => sub {
      my $self = shift;
      $self->load_model('ExtensiveState')->new(
        chara         => $self->chara,
        chara_soldier => $self->soldier,
      );
    },
  );

  with 'Jikkoku::Role::Loader' => {
    -alias    => {
      class   => 'load_class',
      model   => 'load_model',
      service => 'load_service',
    },
    -excludes => [qw/ class model service /],
  };

  __PACKAGE__->meta->make_immutable;

}

__END__

Jikkoku::Class::Chara を拡張したクラス

