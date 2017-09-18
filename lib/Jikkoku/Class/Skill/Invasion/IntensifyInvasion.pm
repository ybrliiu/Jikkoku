package Jikkoku::Class::Skill::Invasion::IntensifyInvasion {

  use Mouse;
  use Jikkoku;

  use constant {
    NEED_FORCE   => 100,
    ACQUIRE_SIGN => 1,
  };

  has 'name'                  => ( is => 'ro', isa => 'Str', default => '侵攻強化' );
  has 'consume_skill_point'   => ( is => 'ro', isa => 'Int', default => 5 );
  has 'increase_attack_power' => ( is => 'ro', isa => 'Int', default => 15 );

  with qw(
    Jikkoku::Class::Skill::Skill
    Jikkoku::Class::Skill::Role::Purchasable
    Jikkoku::Service::BattleCommand::Battle::CharaPower::AttackPowerAdjuster
  );

  around _build_next_skills_id => sub {
    ['Advance'];
  };

  sub is_acquired {
    my $self = shift;
    $self->chara->skill('invasion') =~ /(??{ ACQUIRE_SIGN })/;
  }

  sub acquire {
    my $self = shift;
    $self->chara->skill(invasion => ACQUIRE_SIGN);
  }

  sub description_of_effect_body {
    my $self = shift;
    '侵攻側かつ武力が'
      . $self->NEED_FORCE
      . '以上の時、攻撃力+'
      . $self->increase_attack_power . '。';
  }

  sub adjust_attack_power {
    my ($self, $chara_power_adjuster_service) = @_;
    $self->chara->is_invasion
      && $self->chara->force >= NEED_FORCE ? $self->increase_attack_power : 0;
  }

  __PACKAGE__->meta->make_immutable;

}

1;

