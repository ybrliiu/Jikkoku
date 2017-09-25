package Jikkoku::Service::BattleCommand::Battle::BattleLoop::Chara {

  use Mouse;
  use Jikkoku;

  extends 'Jikkoku::Service::BattleCommand::Battle::Chara';

  has [qw/ power target_power /] => (
    is       => 'ro',
    isa      => 'Jikkoku::Service::BattleCommand::Battle::CharaPower::CharaPower',
    required => 1,
  );

  has 'orig_take_damage'    => ( is => 'ro', isa => 'Int', lazy => 1, builder => '_build_orig_take_damage' );
  has 'take_damage'         => ( is => 'rw', default => 0 );
  has 'first_soldier_num'   => ( is => 'ro', isa => 'Int', builder => '_build_first_soldier_num' );
  has 'increase_contribute' => ( is => 'rw', isa => 'Num', default => 0 );
  has 'event_executers'     => ( is => 'ro', lazy => 1, builder => '_build_event_executers' );

  sub _build_orig_take_damage {
    my $self = shift;
    my $damage  = int( ($self->power->attack_power - $self->target_power->defence_power) / 10 );
    $damage = 0 if $damage < 0;
    $damage += 2;
    $damage;
  }

  sub _build_first_soldier_num {
    my $self = shift;
    $self->soldier->num;
  }

  sub _build_event_executers {
    my $self = shift;
    $self->skills
      ->get_available_skills_with_result
      ->get_battle_event_executer_skills_with_result;
  }

  sub set_new_take_damage {
    my $self = shift;
    if ($self->can_take_damage) {
      my $damage = int(rand $self->orig_take_damage);
      $damage <= 0 ? 1 : $damage;
      $self->take_damage($damage);
    } else {
      $self->take_damage(0);
    }
  }

  sub record_increase_contribute {
    my ($self, $target) = @_;
    $self->increase_contribute( $self->increase_contribute + $target->first_soldier_num - $target->soldier->num );
  }

  sub soldier_status {
    my $self = shift;
    my $chara = $self->chara;
    qq{@{[ $chara->name ]} @{[ $chara->soldier->name ]} (@{[ $chara->soldier->attr]}) @{[ $chara->soldier->num ]}人};
  }

  sub power_status {
    my $self = shift;
    qq{[@{[ $self->is_invasion ? '侵攻' : '防衛' ]}]【@{[ $self->name ]} [@{[ $self->formation->name ]}] ( 攻 : @{[ $self->power->attack_power ]} 守 : @{[ $self->power->defence_power ]} ) 】};
  }

  __PACKAGE__->meta->make_immutable;

}

1;

