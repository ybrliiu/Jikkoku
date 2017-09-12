package Jikkoku::Class::State::AdvanceIncreaseAttackPower {

  # メモ 効果時間は進撃スキル側で定義する

  use Mouse;
  use Jikkoku;

  has 'name'               => ( is => 'ro', isa => 'Str', default => '進撃' );
  has 'attack_power_ratio' => ( is => 'ro', isa => 'Num', default => 0.25 );

  with qw(
    Jikkoku::Class::State::State
    Jikkoku::Class::State::Role::Expires
    Jikkoku::Class::State::Role::AttackPowerAdjuster
  );

  sub description {
    my $self = shift;
    '進撃スキルの効果で攻撃力が' . $self->attack_power_ratio * 100 . '%上昇している状態です。';
  }

  around is_available => sub {
    my ($orig, $self, $time) = @_;
    $self->chara->is_invasion ? $self->$orig($time) : 0;
  };

  __PACKAGE__->meta->make_immutable;

}

1;

