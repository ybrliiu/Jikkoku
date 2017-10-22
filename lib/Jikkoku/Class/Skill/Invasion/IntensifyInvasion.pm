package Jikkoku::Class::Skill::Invasion::IntensifyInvasion {

  use Mouse;
  use Jikkoku;

  use constant {
    ACQUIRE_SIGN      => 1,
    REQUIRE_ABILITIES => {force => 100},
  };

  has 'name'                  => ( is => 'ro', isa => 'Str', default => '侵攻強化' );
  has 'consume_skill_point'   => ( is => 'ro', isa => 'Int', default => 5 );
  has 'increase_attack_power' => ( is => 'ro', isa => 'Int', default => 15 );

  with qw(
    Jikkoku::Class::Skill::Invasion::Invasion
    Jikkoku::Class::Skill::Role::Purchasable
    Jikkoku::Service::BattleCommand::Battle::CharaPower::AttackPowerAdjuster
  );

  around _build_next_skills_id => sub {
    ['Advance'];
  };

  sub description_of_effect_body {
    my $self = shift;
    '侵攻側の時、攻撃力+'
      . $self->increase_attack_power . '。';
  }

  sub adjust_attack_power {
    my ($self, $chara_power_adjuster_service) = @_;
    $self->increase_attack_power;
  }

  __PACKAGE__->meta->make_immutable;

}

1;

