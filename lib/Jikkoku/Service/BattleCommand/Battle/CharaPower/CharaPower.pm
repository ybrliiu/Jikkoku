package Jikkoku::Service::BattleCommand::Battle::CharaPower::CharaPower {
  
  use Mouse;
  use Jikkoku;
  use List::Util qw( sum );

  with 'Jikkoku::Role::Loader';

  for (qw/
    AttackPower DefencePower AttackAndDefencePower
    EnemyAttackPower EnemyDefencePower EnemyAttackAndDefencePower
  /) {
    __PACKAGE__->service("BattleCommand::Battle::CharaPower::AdjusterService::$_");
  }
  
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

  has 'orig_attack_power' => (
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

  has 'chara_power_adjusters' => (
    is      => 'ro',
    isa     => 'ArrayRef[Jikkoku::Service::BattleCommand::Battle::CharaPower::AdjusterService::CharaPower]',
    lazy    => 1,
    builder => '_build_chara_power_adjusters',
  );

  has 'enemy_power_adjusters' => (
    is      => 'ro',
    isa     => 'ArrayRef[Jikkoku::Service::BattleCommand::Battle::CharaPower::AdjusterService::EnemyPower]',
    lazy    => 1,
    builder => '_build_enemy_power_adjusters',
  );

  sub orig_defence_power {
    my $self = shift;
    $self->chara->defence_power;
  }

  sub _build_chara_power_adjusters {
    my $self = shift;
    my $pkg_name = 'Jikkoku::Service::BattleCommand::Battle::CharaPower::AdjusterService';
    my $param = {
      chara              => $self->chara,
      target             => $self->target,
      orig_attack_power  => $self->orig_attack_power,
      orig_defence_power => $self->orig_defence_power,
    };
    my $closure = sub {
      my $adjuster = shift;
      if ( $adjuster->DOES("${pkg_name}::AttackAndDefencePowerAdjuster") ) {
        "${pkg_name}::AttackAndDefencePower"->new(%$param, adjuster => $adjuster);
      }
      elsif ( $adjuster->DOES("${pkg_name}::AttackPowerAdjuster") ) {
        "${pkg_name}::AttackPower"->new(%$param, adjuster => $adjuster);
      }
      else {
        "${pkg_name}::DefencePower"->new(%$param, adjuster => $adjuster);
      }
    };
    [
      map { $closure->($_) } @{ $self->chara->states->get_available_states_with_result->get_chara_power_adjuster_states_with_result },
      map { $closure->($_) } @{ $self->chara->skills->get_chara_power_adjuster_skills },
    ];
  }

  sub _build_enemy_power_adjusters {
    my $self = shift;
    my $pkg_name = 'Jikkoku::Service::BattleCommand::Battle::CharaPower::AdjusterService';
    my $param = {
      chara              => $self->chara,
      target             => $self->target,
      orig_attack_power  => $self->orig_attack_power,
      orig_defence_power => $self->orig_defence_power,
    };
    my $closure = sub {
      my $adjuster = shift;
      if ( $adjuster->DOES("${pkg_name}::AttackAndDefencePowerAdjuster") ) {
        "${pkg_name}::EnemyAttackAndDefencePower"->new(%$param, adjuster => $adjuster);
      }
      elsif ( $adjuster->DOES("${pkg_name}::AttackPowerAdjuster") ) {
        "${pkg_name}::EnemyAttackPower"->new(%$param, adjuster => $adjuster);
      }
      else {
        "${pkg_name}::EnemyDefencePower"->new(%$param, adjuster => $adjuster);
      }
    };
    [
      map { $closure->($_) } @{ $self->target->skills->get_enemy_power_adjuster_skills },
      map { $closure->($_) } @{ $self->target->states->get_available_states_with_result->get_enemy_power_adjuster_states_with_result },
    ];
  }

  sub attack_power {
    my $self = shift;
    $self->orig_attack_power
      + $self->formation_power->attack_power
      + $self->navy_power->attack_power
      + sum( map { $_->adjust_attack_power } @{ $self->chara_power_adjusters } )
      + sum( map { $_->adjust_enemy_attack_power } @{ $self->enemy_power_adjusters } );
  }

  sub defence_power {
    my $self = shift;
    $self->orig_defence_power
      + $self->formation_power->defence_power
      + $self->navy_power->defence_power
      + sum( map { $_->adjust_defence_power } @{ $self->chara_power_adjusters } )
      + sum( map { $_->adjust_enemy_defence_power } @{ $self->enemy_power_adjusters } );
  }

  sub write_to_log {
    my $self = shift;
    $self->weapon_attr_increase_attack_power->write_to_log;
    $self->formation_power->write_to_log;
    $self->navy_power->write_to_log;
    $_->write_to_log for @{ $self->chara_power_adjusters };
    $_->write_to_log for @{ $self->enemy_power_adjusters };
  }

  __PACKAGE__->meta->make_immutable;

}

1;

__END__

# キャラの戦闘時の攻撃力を計算するクラス

