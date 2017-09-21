package Jikkoku::Service::BattleCommand::Battle::CharaPower::FormationPower {

  use Mouse;
  use Jikkoku;

  use constant ARRANGING_DECREASE_RATIO => 0.1;

  has 'change_formation' => (
    is      => 'ro',
    isa     => 'Jikkoku::Service::Chara::Soldier::ChangeFormation',
    lazy    => 1,
    default => sub {
      my $self = shift;
      $self->service('Chara::Soldier::ChangeFormation')->new( chara => $self->chara );
    },
  );

  with qw( Jikkoku::Service::BattleCommand::Battle::CharaPower::CharaPowerCalculator );

  sub _build_attack_power {
    my $self = shift;
    if ( $self->change_formation->is_arranging ) {
      - int( $self->orig_attack_power * ARRANGING_DECREASE_RATIO );
    } else {
      my $formation = $self->chara->formation;
      my $power =
        $formation->increase_attack_power_num +
        ( $self->orig_attack_power * $formation->increase_attack_power_ratio ) +
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
    if ( $self->change_formation->is_arranging ) {
      int( $self->orig_defence_power * ARRANGING_DECREASE_RATIO ) * -1;
    } else {
      my $formation = $self->chara->formation;
      my $power =
        $formation->increase_defence_power_num +
        ( $self->orig_defence_power * $formation->increase_defence_power_ratio ) +
        (
          $formation->is_advantageous( $self->target->formation )
            ? $formation->increase_defence_power_ratio_when_advantageous
            : 0
        );
      int $power;
    }
  }

  sub write_to_log {
    my $self = shift;
    if ( $self->change_formation->is_arranging ) {
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

