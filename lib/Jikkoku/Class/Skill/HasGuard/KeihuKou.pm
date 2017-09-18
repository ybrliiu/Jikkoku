package Jikkoku::Class::Skill::HasGuard::KeihuKou {

  use Mouse;
  use Jikkoku;

  use constant {
    ACQUIRE_SIGN => 3,
    GUARD_NAME   => '軽布甲',
  };

  has 'name'                  => ( is => 'ro', isa => 'Str', default => GUARD_NAME );
  has 'increase_attack_power' => ( is => 'ro', isa => 'Int', default => 20 );

  with qw(
    Jikkoku::Class::Skill::Skill
    Jikkoku::Class::Skill::Role::HasGuard
    Jikkoku::Service::BattleCommand::Battle::CharaPower::AttackPowerAdjuster
  );

  sub description {
    my $self = shift;
    '弓兵使用時、攻撃力+' . $self->increase_attack_power . '。';
  }

  sub adjust_attack_power {
    my ($self, $chara_power_adjuster_service) = @_;
    $self->soldier->attr eq '弓' ? $self->increase_attack_power : 0;
  }

  __PACKAGE__->meta->make_immutable;

}

1;

