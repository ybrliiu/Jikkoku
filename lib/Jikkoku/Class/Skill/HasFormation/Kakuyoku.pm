package Jikkoku::Class::Skill::HasFormation::Kakuyoku {

  use Mouse;
  use Jikkoku;

  has 'name'                        => ( is => 'ro', isa => 'Str', default => '鶴翼陣' );
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
    '自軍兵士が相手兵士の'
      . $self->need_soldier_ratio
      . '倍以上の時、自軍-敵軍だけ攻撃力上昇。上限は'
      . $self->increase_attack_power_limit . '。';
  }

  sub adjust_attack_power {
    my ( $self, $orig_attack_power, $enemy ) = @_;
    if ( $self->chara->soldier->num >= $enemy->soldier->num * $self->need_soldier_ratio ) {
      my $sub = $self->chara->soldier->num - $enemy->soldier->num;
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

