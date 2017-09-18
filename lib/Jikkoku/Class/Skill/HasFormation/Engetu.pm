package Jikkoku::Class::Skill::HasFormation::Engetu {

  use Mouse;
  use Jikkoku;

  has 'name'                        => ( is => 'ro', isa => 'Str', default => '彎月陣' );
  has 'need_soldier_ratio'          => ( is => 'ro', isa => 'Num', default => 4 );
  has 'increase_attack_power_limit' => ( is => 'ro', isa => 'Int', default => 80 );

  with qw(
    Jikkoku::Class::Skill::Skill
    Jikkoku::Class::Skill::Role::HasFormation
    Jikkoku::Service::BattleCommand::Battle::CharaPower::AttackPowerAdjuster
  );

  sub is_acquired {
    my $self = shift;
    $self->chara->formation->name eq $self->name;
  }

  sub acquire {}

  sub description_of_effect_body {
    my $self = shift;
    '自軍兵士が相手兵士の1/'
      . $self->need_soldier_ratio
      . '倍以下の時、敵軍-自軍だけ攻撃力上昇。上限は'
      . $self->increase_attack_power_limit . '。';
  }

  sub adjust_attack_power {
    my ($self, $chara_power_adjuster_service) = @_;
    my $enemy = $chara_power_adjuster_service->target;
    if ( $self->chara->soldier->num <= $enemy->soldier->num / $self->need_soldier_ratio ) {
      my $sub = $enemy->soldier->num - $self->chara->soldier->num;
      $sub > $self->increase_attack_power_limit ? $self->increase_attack_power_limit
        : $sub < 0 ? 0
        : $sub;
    } else {
      0;
    }
  }

  __PACKAGE__->meta->make_immutable;

}

1;

