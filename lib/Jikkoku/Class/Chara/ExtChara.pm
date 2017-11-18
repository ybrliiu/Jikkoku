package Jikkoku::Class::Chara::ExtChara {

  use Mouse;
  use Jikkoku;

  use Jikkoku::Util qw( decamelize );
  use Jikkoku::Class::Chara;

  {
    my @chara_attributes = Jikkoku::Class::Chara->get_column_attributes;

    my @delegations = (
      ( map { $_->name } @chara_attributes ),
      # alias methods
      (
        map  { substr($_->name, 1) }
        grep { $_->isa('Jikkoku::Class::Role::TextData::Attribute::HashField') } @chara_attributes
      ),
      qw/ is_neutral is_dummy check_pass /,
      qw/ commit lock save abort /,
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
      $self->load_class('Chara::Soldier')->new( { %$soldier_data, chara => $self } );
    },
  );

  has 'formation' => (
    is      => 'ro',
    isa     => 'Jikkoku::Class::Formation',
    lazy    => 1,
    default => sub {
      my $self = shift;
      my $orig = $self->load_model('Formation')
        ->instance->get( $self->_soldier_battle_map->get('formation_id') );
      $self->load_class('Chara::Formation')->new({ %$orig, chara => $self });
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

  has 'guard' => (
    is      => 'ro',
    isa     => 'Jikkoku::Class::Chara::Guard',
    lazy    => 1,
    default => sub {
      my $self = shift;
      $self->load_class('Chara::Guard')->new( chara => $self->chara );
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

  has 'profile_model' => (
    is      => 'ro',
    isa     => 'Jikkoku::Model::Chara::Profile',
    lazy    => 1,
    default => sub {
      my $self = shift;
      $self->load_model('Chara::Profile')->new;
    },
  );

  has 'profile' => (
    is      => 'ro',
    isa     => 'Jikkoku::Class::Chara::Profile',
    lazy    => 1,
    default => sub {
      my $self = shift;
      $self->profile_model->get( $self->id );
    },
  );

  has 'country' => (
    is      => 'ro',
    isa     => 'Jikkoku::Class::Country::ExtCountry',
    lazy    => 1,
    default => sub {
      my $self = shift;
      my $country = $self->country_model->get_with_option( $self->chara->country_id )->match(
        Some => sub { $_ },
        None => sub { $self->country_model->neutral },
      );
      $self->load_class('Country::ExtCountry')->new({
        country       => $country,
        town_model    => $self->town_model,
        chara_model   => $self->chara_model,
        country_model => $self->country_model,
      });
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

  for my $name (qw/ chara town country /) {
    my $class_name = ucfirst $name;
    has "${name}_model" => (
      is      => 'ro',
      isa     => "Jikkoku::Model::$class_name",
      lazy    => 1,
      default => sub { $_[0]->load_model($class_name)->new },
    );
  }

  for my $class_name (qw/ Skill State BattleMode /) {
    my $attr_name = decamelize $class_name . 's';
    has $attr_name => (
      is      => 'ro',
      isa     => "Jikkoku::Model::${class_name}::Result",
      lazy    => 1,
      default => sub {
        my $self = shift;
        $self->load_model($class_name)->new(chara => $self)->get_all_with_result;
      },
    );
  }

  has 'extensive_state_record_model' => (
    is      => 'ro',
    isa     => 'Jikkoku::Model::ExtensiveStateRecord',
    lazy    => 1,
    default => sub {
      my $self = shift;
      $self->load_model('ExtensiveStateRecord')->new;
    },
  );

  has 'extensive_states' => (
    is      => 'ro',
    isa     => 'Jikkoku::Model::ExtensiveState::Result',
    lazy    => 1,
    default => sub {
      my $self = shift;
      $self->load_model('ExtensiveState')->new(
        chara         => $self,
        chara_soldier => $self->soldier,
        record_model  => $self->extensive_state_record_model,
      )->get_all_with_result;
    },
  );

  has 'position' => (
    is      => 'ro',
    isa     => 'Option::Option',
    lazy    => 1,
    default => sub {
      my $self = shift;
      $self->country->position_of_chara_with_option($self);
    },
  );

  with 'Jikkoku::Role::Loader' => {
    -alias => {
      class   => 'load_class',
      model   => 'load_model',
      service => 'load_service',
    },
    -excludes => [qw/ class model service /],
  };

  sub attack_power {
    my $self = shift;
    $self->soldier->attack_power(@_) + $self->force + $self->weapon->power + 
    $self->position->match(
      Some => sub { $_->increase_attack_power },
      None => sub { 0 },
    );
  }

  sub defence_power {
    my $self = shift;
    $self->soldier->defence_power(@_) + ($self->soldier->training / 2) + $self->guard->power +
    $self->position->match(
      Some => sub { $_->increase_defence_power },
      None => sub { 0 },
    );
  }

  __PACKAGE__->_generate_save_log_method;

  sub _generate_save_log_method {
    my $class = shift;
    my $meta = $class->meta;
    for (qw/ command battle /) {
      my $method_name = "save_${_}_log";
      my $logger_name = "${_}_logger";
      $meta->add_method($method_name => sub {
        my ($self, $str) = @_;
        $self->$logger_name->add($str)->save;
      });
    }
  }

  __PACKAGE__->meta->make_immutable;

}

__END__

Jikkoku::Class::Chara を拡張したクラス

