package Jikkoku::Service::BattleCommand::Battle::WeaponAttr {

  use Mouse;
  use Jikkoku;
  use Jikkoku::Util qw( validate_values );

  use constant {
    BASIC_INCREASE_WAPON_ATTR_POWER => 0.45,
    MIN_INCREASE_WAPON_ATTR_POWER   => 0.15,
  };

  has 'chara_weapon' => (
    is       => 'ro',
    isa      => 'Jikkoku::Class::Chara::Weapon',
    required => 1,
  );

  has [qw/ chara_soldier target_soldier /] => (
    is       => 'ro',
    isa      => 'Jikkoku::Class::Chara::Soldier',
    required => 1,
  );

  has [qw/ chara_battle_logger target_battle_logger /] => (
    is       => 'ro',
    isa      => 'Jikkoku::Class::Chara::BattleLog',
    required => 1,
  );

  sub is_advantage {
    my $self = shift;
    grep { $self->target_soldier->attr eq $_ } @{ $self->chara_weapon->attr->advantageous_attrs };
  }

  sub is_weapon_and_soldier_same_attr {
    my $self = shift;
    $self->chara_soldier->attr eq $self->chara_weapon->attr->name;
  }

  sub increase_attack_power {
    my $self = shift;
    my $attr = $self->chara_weapon->attr;
    int $self->chara_weapon->attr_power * do {
      if ( $self->is_advantage && $self->is_weapon_and_soldier_same_attr ) {
        $attr->increase_attack_power_coef_when_advantageous_and_soldier_has_same_attr;
      } elsif ( $self->is_advantage ) {
        $attr->increase_attack_power_coef_when_advantageous;
      } elsif ( $self->is_weapon_and_soldier_same_attr ) {
        $attr->increase_attack_power_coef_when_soldier_has_same_attr;
      } else {
        0;
      }
    };
  }

  sub does_weapon_attr_power_increase {
    my $self = shift;
    my $attr = $self->chara_weapon->attr;
    ( $self->is_advantage && $attr->is_attr_power_increase_when_advantageous ) ||
    ( $self->is_weapon_and_soldier_same_attr
      && $attr->is_attr_power_increase_when_soldier_has_same_attr );
  }

  sub increase_weapon_attr_power {
    my ($self, $args) = @_;
    validate_values $args => [qw/ is_win /];
    my $weapon = $self->chara_weapon;
    if ( $self->does_weapon_attr_power_increase ) {
      my $add_power = BASIC_INCREASE_WAPON_ATTR_POWER + do {
        if ( $args->{is_win} ) {
          if ( $weapon->attr_power < 25 ) {
            2.55;
          } elsif ( $weapon->attr_power < 50 ) {
            1.8;
          } else {
            my $ret = 1.95 - int( $weapon->attr_power / 25 ) * 0.3;
            $ret < MIN_INCREASE_WAPON_ATTR_POWER ? MIN_INCREASE_WAPON_ATTR_POWER : $ret;
          }
        } else {
          0;
        }
      };
      $weapon->add_attr_power($add_power);
    }
  }

  __PACKAGE__->meta->make_immutable;

}

1;

