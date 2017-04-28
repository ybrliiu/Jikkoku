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

  sub ensure_can_exec {
  }

  sub exec {
    # ここはべたーっと書いていって、そのうちRole化する
  }

  __PACKAGE__->meta->make_immutable;

}

1;
