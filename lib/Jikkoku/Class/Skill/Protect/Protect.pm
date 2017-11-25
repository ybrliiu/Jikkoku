package Jikkoku::Class::Skill::Protect::Protect {

  use Mouse;
  use Jikkoku;

  use Jikkoku::Util qw( validate_values );

  has 'name'           => ( is => 'ro', default => '掩護' );
  has 'consume_morale' => ( is => 'rw', default => 10 );
  has 'get_contribute' => ( is => 'rw', default => 2 );
  has 'effect_range'   => ( is => 'rw', default => 3 );
  has 'effect_time'    => ( is => 'rw', default => 250 );
  has 'interval_time'  => ( is => 'rw', default => 240 );
  has 'success_ratio'  => ( is => 'rw', default => 1 );

  with qw(
    Jikkoku::Class::Skill::Skill
    Jikkoku::Class::Skill::Role::UsedInBattleMap::SustainingEffect
    Jikkoku::Class::Skill::Role::UsedInBattleMap::NotDependOnAbilities
  );

  sub is_acquired {
    my $self = shift;
    $self->chara->soldier->attr eq '歩';
  }

  sub acquire {}

  sub description_of_effect_body {
    my $self = shift;
<< "EOS";
使用後@{[ $self->effect_time ]}秒間、
自分の周囲@{[ $self->effect_range ]}マス以内にいる味方が敵の攻撃を受けた時、
身代わりになって攻撃を受ける。(行動)
EOS
  }

  around description_of_acquire_body => sub {
    "歩兵属性兵科を使用時。";
  };

  # 後ほど再使用時間発生するスキルのロールを作成
  around description_of_status_body => sub {
    my ($orig, $self) = @_;
    "再使用時間 : @{[ $self->interval_time ]}秒";
  };

  __PACKAGE__->meta->make_immutable;

}

1;
