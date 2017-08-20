package Jikkoku::Service::BattleCommand::Battle::CharaPower::CharaPower {
  
  use Mouse;
  use Jikkoku;

  has [qw/ chara target /] => (
    is       => 'ro',
    isa      => 'Jikkoku::Class::Chara::ExtChara',
    required => 1,
  );

  has 'weapon_attr_affinity' => (
    is      => 'ro',
    isa     => 'Jikkoku::Service::BattleCommand::Battle::WeaponAttrAffinity',
    lazy    => 1,
    default => sub {
      my $self = shift;
      $self->service('BattleCommand::Battle::WeaponAttrAffinity')->new({
        chara  => $self->chara,
        target => $self->target,
      });
    },
  );

  has 'weapon_attr_increase_attack_power' => (
    is      => 'ro',
    isa     => 'Jikkoku::Service::BattleCommand::Battle::CharaPower::WeaponAttrIncreaseAttackPower',
    lazy    => 1,
    default => sub {
      my $self = shift;
      $self->service('BattleCommand::Battle::WeaponAttrIncreaseAttackPower')
        ->new( weapon_attr_affinity => $self->weapon_attr_affinity );
    },
  );

  has 'attack_power_orig' => (
    is      => 'ro',
    isa     => 'Int',
    lazy    => 1,
    default => sub {
      my $self = shift;
      $self->chara->attack_power + $self->weapon_attr_increase_attack_power->increase_attack_power;
    },
  );

  has 'formation_power' => (
    is      => 'ro',
    isa     => 'Jikkoku::Service::BattleCommand::Battle::CharaPower::FormationPower',
    lazy    => 1,
    default => sub {
      my $self = shift;
      $self->service('BattleCommand::Battle::FormationPower')->new(chara_power => $self);
    },
  );

  has 'navy_power' => (
    is      => 'ro',
    isa     => 'Jikkoku::Service::BattleCommand::Battle::CharaPower::NavyPower',
    lazy    => 1,
    default => sub {
      my $self = shift;
      $self->service('BattleCommand::Battle::NavyPower')->new(chara_power => $self);
    },
  );

  with 'Jikkoku::Role::Loader';

  sub defence_power_orig {
    my $self = shift;
    $self->chara->defence_power;
  }

  sub attack_power {
    my $self = shift;
    $self->attack_power_orig
      + $self->formation_power->attack_power
      + $self->navy_power->attack_power;
  }

  sub defence_power {
    my $self = shift;
    $self->defence_power_orig
      + $self->formation_power->defence_power
      + $self->navy_power->defence_power;
  }

  sub write_to_log {
    my $self = shift;
    $self->weapon_attr_increase_attack_power->write_to_log;
    $self->formation_power->write_to_log;
    $self->navy_power->write_to_log;
  }

  __PACKAGE__->meta->make_immutable;

}

1;

__END__

# キャラの戦闘時の攻撃力を計算するクラス

