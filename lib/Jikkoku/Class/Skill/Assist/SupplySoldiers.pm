# 補給スキル

package Jikkoku::Class::Skill::Assist {

  use Mouse;
  use Jikkoku;

  use constant ACQUIRE_SIGN => 1;

  has 'name' => ( is => 'ro', isa => 'Str', default => '補給' );
  has 'range' => ( is => 'ro', isa => 'Int', default => 1 );

  has 'sucess_coef'          => ( is => 'rw', default => 0.005 );
  has 'max_sucess_ratio'        => ( is => 'rw', default => 0.8 );
  has 'consume_morale'       => ( is => 'rw', default => 12 );
  has 'get_contribute_coef'  => ( is => 'rw', default => 0.01 );
  has 'add_book_power'       => ( is => 'rw', default => 0.05 );
  has 'min_effect_time_coef' => ( is => 'rw', default => 2.5 );
  has 'max_effect_time_coef' => ( is => 'rw', default => 3.5 );
  has 'action_interval_time' => ( is => 'rw', default => $CONFIG->{game}{action_interval_time} * 0.5 );
  has 'consume_skill_point'  => ( is => 'rw', default => 10 );
  has 'depend_abilities'     => ( is => 'rw', lazy => 1, default => sub { ['intellect'] } );

  with qw(
    Jikkoku::Class::Skill::Skill
    Jikkoku::Class::Skill::Role::UsedInBattleMap
    Jikkoku::Class::Skill::Role::Purchasable
  );

  around _build_next_skill => sub {
    [ 'SmallDivineProtection', 'SmallFeint' ];
  };

  sub is_acquired {
    my $self = shift;
    $self->chara->skill('assist') >= ACQUIRE_SIGN;
  }

  sub acquire {
    my $self = shift;
    # Skill.pm : 前のスキルを習得しているか確認
    $self->chara->(assist => ACQUIRE_SIGN);
  }

  sub explain_effect_simple {
    my $self = shift;
<< 'EOS';
自軍兵士が統率力の半分以上いるとき、自軍兵士を少し味方の部隊に引き渡す。<br>
引き渡した人数×相手兵種の値段 相手の金は減少する。<br>
また、引き渡した人数分引き渡された軍の訓練値は減少する。<br>
ただし、引き渡す側と引き渡される側の兵種が同じ場合、金と訓練値は減少しない。<br>
EOS
  }

  sub explain_acquire {
    # Skill.pm : @{[ 前スキル名 ]}を修得していること
  }

  sub ensure_can_action {
  }

  sub action {
    # ここはべたーっと書いていって、そのうちRole化する
  }

  __PACKAGE__->meta->make_immutable;

}

1;
