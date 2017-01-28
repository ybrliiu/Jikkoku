package Jikkoku::Class::Skill::Role::BattleAction {

  use Jikkoku;
  use Role::Tiny;
  use Role::Tiny::With;
  with 'Jikkoku::Class::Role::BattleAction';

  use Jikkoku::Util qw( validate_values );

  requires qw(
    ensure_can_action
    action

    explain_effect
    explain_effect_simple
    explain_status
    explain_acquire

    _build_next_skill
    acquire
    is_acquired
  );

  around new => sub {
    my ($orig, $class, $args) = @_;
    my $self = $class->$orig($args);
    $self->{map_log_model}    = undef;
    $self->{battle_map_model} = undef;
    $self;
  };

  before ensure_can_action => sub {
    my ($self, $args) = @_;
    validate_values $args => [qw/map_log_model battle_map_model/];
    $self->{map_log_model}    = $args->{map_log_model};
    $self->{battle_map_model} = $args->{battle_map_model};

    throw("$self->{name}スキルを修得していません。") unless $self->is_acquired;
  };

}

1;
