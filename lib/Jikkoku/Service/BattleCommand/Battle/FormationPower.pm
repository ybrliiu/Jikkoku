package Jikkoku::Service::BattleCommand::Battle::FormationPower {

  use Mouse;
  use Jikkoku;

  use constant ARRANGING_DECREASE_RATIO => 0.1;
  
  has 'chara_power' => (
    is       => 'ro',
    isa      => 'Jikkoku::Service::BattleCommand::Battle::CharaPower',
    handles  => [qw/ chara target attack_power_orig defence_power_orig /],
    required => 1,
  );

  has 'change_formation' => (
    is      => 'ro',
    isa     => 'Jikkoku::Service::Chara::Soldier::ChangeFormation',
    lazy    => 1,
    default => sub {
      my $self = shift;
      $self->service('Chara::Soldier::ChangeFormation')->new( chara => $self->chara );
    },
  );

  has 'attack_power' => (
    is      => 'ro',
    isa     => 'Int',
    lazy    => 1,
    builder => '_build_attack_power',
  );

  has 'defence_power' => (
    is      => 'ro',
    isa     => 'Int',
    lazy    => 1,
    builder => '_build_defence_power',
  );

  sub _build_attack_power {
    my $self = shift;
    if ( $self->change_formation_service->is_arranging ) {
      - int( $self->attack_power_orig * ARRANGING_DECREASE_RATIO );
    } else {
      my $formation = $self->chara->formation;
      my $power =
        $formation->increase_attack_power_num +
        ( $self->attack_power_orig * $formation->increase_attack_power_ratio ) +
        (
          $formation->is_advantageous( $self->target->formation )
            ? $formation->increase_attack_power_ratio_when_advantageous
            : 0
        );
      int $power;
    }
  }

  sub _build_defence_power {
    my $self = shift;
    if ( $self->change_formation_service->is_arranging ) {
      - int( $self->defence_power_orig * ARRANGING_DECREASE_RATIO );
    } else {
      my $formation = $self->chara->formation;
      my $power =
        $formation->increase_defence_power_num +
        ( $self->defence_power_orig * $formation->increase_defence_power_ratio ) +
        (
          $formation->is_advantageous( $self->target->formation )
            ? $formation->increase_defence_power_ratio_when_advantageous
            : 0
        );
      int $power;
    }
  }

  sub exec {
    my $self = shift;
    if ( $self->change_formation_service->is_arranging ) {
      my $log = sub {
        my $color = shift;
        qq{<span class="$color">【陣形編成中...】</span>@{[ $self->chara->name ]}は}
        . qq{陣形を整えている途中なので攻撃力が<span class="red">@{[ $self->attack_power ]}</span>、}
        . qq{守備力が<span class="red">@{[ $self->defence_power ]}</span>されました。};
      };
      $self->chara->battle_logger->add( $log->('red') );
      $self->target->battle_logger->add( $log->('blue') );
    }
  }

  __PACKAGE__->meta->make_immutable;

}

1;

