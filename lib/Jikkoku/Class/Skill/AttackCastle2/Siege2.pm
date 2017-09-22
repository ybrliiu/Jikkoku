package Jikkoku::Class::Skill::AttackCastle2::Siege2 {

  use Mouse::Role;
  use Jikkoku;

  # constants
  requires qw( ACQUIRE_SIGN ACQUIRE_SIEGE_COUNT );

  # attributes
  requires qw( increase_turn );

  with qw( Jikkoku::Service::BattleCommand::Battle::TurnAdjuster );

  around description_of_acquire_about_before_skills => sub { '' };

  sub is_acquired {
    my $self = shift;
    $self->chara->_buffer_and_reward_and_command_skill->get('siege_skill') >= $self->ACQUIRE_SIGN;
  }

  sub acquire_conditions_of_practice_skill {
    my $self = shift;
    $self->chara->_battle_and_command_record->get('siege_count') >= $self->ACQUIRE_SIEGE_COUNT;
  }

  sub acquire {
    my $self = shift;
    $self->chara->_buffer_and_reward_and_command_skill->set(siege_skill => $self->ACQUIRE_SIGN);
  }

  around description_of_effect_body => sub {
    my ($orig, $self) = @_;
    '攻城時ターン数+' . $self->increase_turn . '。';
  };

  around description_of_acquire_body => sub {
    my ($orig, $self) = @_;
    '攻城戦を' . $self->ACQUIRE_SIEGE_COUNT . '回行う。';
  };

  sub adjust_battle_turn {
    my $self = shift;
    $self->increase_turn;
  }

}

1;

