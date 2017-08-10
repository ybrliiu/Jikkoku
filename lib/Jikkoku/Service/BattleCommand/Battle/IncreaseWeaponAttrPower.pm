package Jikkoku::Service::BattleCommand::Battle::IncreaseWeaponAttrPower {

  use Mouse;
  use Jikkoku;

  use constant {
    GROW_INTERVAL                   => 25,
    BASIC_INCREASE_WAPON_ATTR_POWER => 0.45,
    MIN_INCREASE_WAPON_ATTR_POWER   => 0.15,
  };

  has 'weapon_attr_affinity' => (
    is       => 'ro',
    isa      => 'Jikkoku::Service::BattleCommand::Battle::WeaponAttrAffinity',
    handles  => [qw/ chara target is_advantage is_weapon_and_soldier_same_attr /],
    required => 1,
  );

  has 'is_win' => (
    is       => 'ro',
    isa      => 'Bool',
    required => 1,
  );

  has 'does_weapon_attr_power_increase' => (
    is      => 'ro',
    isa     => 'Bool',
    lazy    => 1,
    builder => '_build_does_weapon_attr_power_increase',
  );

  has 'increase_weapon_attr_power' => (
    is      => 'ro',
    isa     => 'Num',
    lazy    => 1,
    builder => '_build_increase_weapon_attr_power',
  );

  sub _build_does_weapon_attr_power_increase {
    my $self = shift;
    my $attr = $self->chara->weapon->attr;
    ( $self->is_advantage && $attr->is_attr_power_increase_when_advantageous ) ||
    ( $self->is_weapon_and_soldier_same_attr
      && $attr->is_attr_power_increase_when_soldier_has_same_attr );
  }

  sub _build_increase_weapon_attr_power {
    my $self = shift;
    my $weapon = $self->chara->weapon;
    if ( $self->does_weapon_attr_power_increase ) {
      my $add_power = BASIC_INCREASE_WAPON_ATTR_POWER + do {
        if ( $self->is_win ) {
          if ( $weapon->attr_power < GROW_INTERVAL ) {
            2.55;
          } elsif ( $weapon->attr_power < GROW_INTERVAL * 2 ) {
            1.8;
          } else {
            my $ret = 1.95 - int( $weapon->attr_power / GROW_INTERVAL ) * 0.3;
            $ret < MIN_INCREASE_WAPON_ATTR_POWER ? MIN_INCREASE_WAPON_ATTR_POWER : $ret;
          }
        } else {
          0;
        }
      };
      $weapon->attr_power( $weapon->attr_power + $add_power );
    }
  }

  sub log {
    my $self = shift;
    $self->does_weapon_attr_power_increase ? "、武器相性が+@{[ $self->increase_weapon_attr_power ]}" : '';
  }

  __PACKAGE__->meta->make_immutable;

}

1;

__END__

=head1
  
  戦闘によって成長する武器相性値に関するクラス

=cut

