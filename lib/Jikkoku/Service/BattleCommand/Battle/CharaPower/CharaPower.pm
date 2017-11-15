package Jikkoku::Service::BattleCommand::Battle::CharaPower::CharaPower {
  
  use Mouse;
  use Jikkoku;
  use List::Util qw( sum );

  with 'Jikkoku::Role::Loader';

  use Jikkoku::Service::BattleCommand::Battle::WeaponAttrAffinity;
  use Jikkoku::Service::BattleCommand::Battle::CharaPower::NavyPower;
  use Jikkoku::Service::BattleCommand::Battle::CharaPower::FormationPower;
  use Jikkoku::Service::BattleCommand::Battle::CharaPower::WeaponAttrIncreaseAttackPower;
  use Jikkoku::Service::BattleCommand::Battle::CharaPower::AdjusterService::AttackPower;
  use Jikkoku::Service::BattleCommand::Battle::CharaPower::AdjusterService::DefencePower;
  use Jikkoku::Service::BattleCommand::Battle::CharaPower::AdjusterService::AttackAndDefencePower;
  use Jikkoku::Service::BattleCommand::Battle::CharaPower::AdjusterService::EnemyAttackPower;
  use Jikkoku::Service::BattleCommand::Battle::CharaPower::AdjusterService::EnemyDefencePower;
  use Jikkoku::Service::BattleCommand::Battle::CharaPower::AdjusterService::EnemyAttackAndDefencePower;
  
  has [qw/ chara target /] => (
    is       => 'ro',
    isa      => 'Jikkoku::Service::BattleCommand::Battle::Chara',
    required => 1,
  );

  # 攻城戦かどうか
  has 'is_siege' => ( is => 'ro', isa => 'Bool', required => 1 );

  has 'weapon_attr_affinity' => (
    is      => 'ro',
    isa     => 'Jikkoku::Service::BattleCommand::Battle::WeaponAttrAffinity',
    lazy    => 1,
    default => sub {
      my $self = shift;
      Jikkoku::Service::BattleCommand::Battle::WeaponAttrAffinity->new({
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
      Jikkoku::Service::BattleCommand::Battle::CharaPower::WeaponAttrIncreaseAttackPower
        ->new( weapon_attr_affinity => $self->weapon_attr_affinity );
    },
  );

  has 'orig_attack_power' => (
    is      => 'ro',
    isa     => 'Int',
    lazy    => 1,
    default => sub {
      my $self = shift;
      $self->chara->attack_power({is_siege => $self->is_siege})
        + $self->weapon_attr_increase_attack_power->increase_attack_power;
    },
  );

  has 'orig_defence_power' => (
    is      => 'ro',
    isa     => 'Int',
    lazy    => 1,
    default => sub {
      my $self = shift;
      $self->chara->defence_power({is_siege => $self->is_siege})
    },
  );

  has 'formation_power' => (
    is      => 'ro',
    isa     => 'Jikkoku::Service::BattleCommand::Battle::CharaPower::FormationPower',
    lazy    => 1,
    default => sub {
      my $self = shift;
      Jikkoku::Service::BattleCommand::Battle::CharaPower::FormationPower
        ->new(chara_power => $self);
    },
  );

  has 'navy_power' => (
    is      => 'ro',
    isa     => 'Jikkoku::Service::BattleCommand::Battle::CharaPower::NavyPower',
    lazy    => 1,
    default => sub {
      my $self = shift;
      Jikkoku::Service::BattleCommand::Battle::CharaPower::NavyPower
        ->new(chara_power => $self);
    },
  );

  sub chara_power_adjusters {
    my $self = shift;
    my $role_pkg_name = 'Jikkoku::Service::BattleCommand::Battle::CharaPower';
    my $pkg_name      = $role_pkg_name . '::AdjusterService';
    my $param = {
      chara              => $self->chara,
      target             => $self->target,
      orig_attack_power  => $self->orig_attack_power,
      orig_defence_power => $self->orig_defence_power,
    };
    my $closure = sub {
      my $adjuster = shift;
      if ( $adjuster->DOES("${role_pkg_name}::AttackAndDefencePowerAdjuster") ) {
        "${pkg_name}::AttackAndDefencePower"->new(%$param, adjuster => $adjuster);
      }
      elsif ( $adjuster->DOES("${role_pkg_name}::AttackPowerAdjuster") ) {
        "${pkg_name}::AttackPower"->new(%$param, adjuster => $adjuster);
      }
      else {
        "${pkg_name}::DefencePower"->new(%$param, adjuster => $adjuster);
      }
    };
    [
      $self->chara->battle_mode->DOES('Jikkoku::Service::BattleCommand::Battle::CharaPower::CharaPowerAdjuster')
        ? $closure->($self->chara->battle_mode) : (),
      ( map { $closure->($_) } @{ $self->chara->states->get_available_states_with_result->get_chara_power_adjuster_states_with_result } ),
      ( map { $closure->($_) } @{ $self->chara->skills->get_available_skills_with_result->get_chara_power_adjuster_skills_with_result } ),
    ];
  }

  sub enemy_power_adjusters {
    my $self = shift;
    my $role_pkg_name = 'Jikkoku::Service::BattleCommand::Battle::CharaPower';
    my $pkg_name      = $role_pkg_name . '::AdjusterService';
    my $param = {
      chara              => $self->chara,
      target             => $self->target,
      orig_attack_power  => $self->orig_attack_power,
      orig_defence_power => $self->orig_defence_power,
    };
    my $closure = sub {
      my $adjuster = shift;
      if ( $adjuster->DOES("${role_pkg_name}::AttackAndDefencePowerAdjuster") ) {
        "${pkg_name}::EnemyAttackAndDefencePower"->new(%$param, adjuster => $adjuster);
      }
      elsif ( $adjuster->DOES("${role_pkg_name}::AttackPowerAdjuster") ) {
        "${pkg_name}::EnemyAttackPower"->new(%$param, adjuster => $adjuster);
      }
      else {
        "${pkg_name}::EnemyDefencePower"->new(%$param, adjuster => $adjuster);
      }
    };
    [
      $self->target->battle_mode->DOES('Jikkoku::Service::BattleCommand::Battle::CharaPower::EnemyPowerAdjuster')
        ? $closure->($self->target->battle_mode) : (),
      ( map { $closure->($_) } @{ $self->target->states->get_available_states_with_result->get_enemy_power_adjuster_states_with_result } ),
      ( map { $closure->($_) } @{ $self->target->skills->get_available_skills_with_result->get_enemy_power_adjuster_skills_with_result } ),
    ];
  }

  sub attack_power {
    my $self = shift;
    $self->orig_attack_power
      + $self->formation_power->attack_power
      + $self->navy_power->attack_power
      + ( sum( map { $_->adjust_attack_power } @{ $self->chara_power_adjusters } ) // 0 )
      + ( sum( map { $_->adjust_enemy_attack_power } @{ $self->enemy_power_adjusters } ) // 0 )
  }

  sub defence_power {
    my $self = shift;
    $self->orig_defence_power
      + $self->formation_power->defence_power
      + $self->navy_power->defence_power
      + ( sum( map { $_->adjust_defence_power } @{ $self->chara_power_adjusters } ) // 0 )
      + ( sum( map { $_->adjust_enemy_defence_power } @{ $self->enemy_power_adjusters } ) // 0 )
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

