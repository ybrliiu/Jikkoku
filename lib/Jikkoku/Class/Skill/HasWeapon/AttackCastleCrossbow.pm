package Jikkoku::Class::Skill::HasWeapon::AttackCastleCrossbow {

  use Mouse;
  use Jikkoku;

  use constant ACQUIRE_SIGN => 7;

  has 'name'                   => ( is => 'ro', isa => 'Str', default => '攻城弩' );
  has 'increase_turn'          => ( is => 'ro', isa => 'Int', default => 1 );
  has 'increase_attack_power'  => ( is => 'ro', isa => 'Int', default => 80 );
  has 'increase_defence_power' => ( is => 'ro', isa => 'Int', default => 40 );

  with qw(
    Jikkoku::Class::Skill::Skill
    Jikkoku::Class::Skill::Role::HasWeapon
    Jikkoku::Service::BattleCommand::Battle::CharaPower::AttackPowerAdjuster
    Jikkoku::Service::BattleCommand::Battle::CharaPower::DefencePowerAdjuster
  );

  sub description {
    my $self = shift;
    '攻城時攻撃力+'
      . $self->increase_attack_power
      . '、守備力+'
      . $self->increase_defence_power
      . '、ターン数+'
      . $self->increase_turn . '。';
  }

  sub adjust_attack_power {
  }

  sub adjust_defence_power {
  }

  __PACKAGE__->meta->make_immutable;

}

1;

