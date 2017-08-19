package Jikkoku::Service::BattleCommand::Battle::WeaponAttrIncreaseAttackPower {

  use Mouse;
  use Jikkoku;

  has 'weapon_attr_affinity' => (
    is       => 'ro',
    isa      => 'Jikkoku::Service::BattleCommand::Battle::WeaponAttrAffinity',
    handles  => [qw/ chara target is_advantage is_weapon_and_soldier_same_attr /],
    required => 1,
  );

  has 'ratio' => (
    is      => 'ro',
    isa     => 'Num',
    lazy    => 1,
    builder => '_build_ratio',
  );

  has 'increase_attack_power' => (
    is      => 'ro',
    isa     => 'Int',
    lazy    => 1,
    builder => '_build_increase_attack_power',
  );
  
  sub _build_ratio {
    my $self = shift;
    my $attr = $self->chara->weapon->attr;
    if ( $self->is_advantage && $self->is_weapon_and_soldier_same_attr ) {
      $attr->increase_attack_power_coef_when_advantageous_and_soldier_has_same_attr;
    } elsif ( $self->is_advantage ) {
      $attr->increase_attack_power_coef_when_advantageous;
    } elsif ( $self->is_weapon_and_soldier_same_attr ) {
      $attr->increase_attack_power_coef_when_soldier_has_same_attr;
    } else {
      0;
    }
  }

  sub _build_increase_attack_power {
    my $self = shift;
    int $self->chara->weapon->attr_power * $self->ratio;
  }

  sub exec {
    my $self = shift;
    if ( $self->coef != 0 ) {
      my $log = sub {
        my $chara = shift;
        my $color = $chara->is_attack ? 'red' : 'blue';
        qq{<span class="$color">【武器相性】</span>@{[ $self->chara->name ]}の攻撃力が}
        . $self->increase_attack_power . '上昇しました！';
      };
      $self->chara->battle_logger->add( $log->($self->chara) );
      $self->target->battle_logger->add( $log->($self->target) );
    }
  }

}

1;

__END__

=head1

  武器相性で上昇する攻撃力に関するクラス

=cut

