package Jikkoku::Class::Skill::HasWeapon::Saku {

  use Mouse;
  use Jikkoku;

  use constant {
    ACQUIRE_SIGN        => 7,
    WEAPON_NAME         => '槊',
    TARGET_SOLDIER_NAME => '槍騎兵',
  };

  has 'name'                  => ( is => 'ro', isa => 'Str', default => WEAPON_NAME );
  has 'increase_attack_power' => ( is => 'ro', isa => 'Int', default => 10 );

  with qw(
    Jikkoku::Class::Skill::Skill
    Jikkoku::Class::Skill::Role::HasWeapon
    Jikkoku::Service::BattleCommand::Battle::CharaPower::AttackPowerAdjuster
  );

  sub description {
    my $self = shift;
    TARGET_SOLDIER_NAME . '使用時、攻撃力が+' . $self->increase_attack_power . 'されます。';
  }

  sub adjust_attack_power {
    my ($self, $chara_power_adjuster_service) = @_;
    $self->chara->soldier->name eq TARGET_SOLDIER_NAME ? $self->increase_attack_power : 0;
  }

  __PACKAGE__->meta->make_immutable;

}

1;

