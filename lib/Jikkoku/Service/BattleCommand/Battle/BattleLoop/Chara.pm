package Jikkoku::Service::BattleCommand::Battle::BattleLoop::Chara {

  use Mouse;
  use Jikkoku;

  use constant ADJUST_MAX_TAKE_DAMAGE => 1;

  extends 'Jikkoku::Service::BattleCommand::Battle::Chara';

  has [qw/ power target_power /] => (
    is       => 'ro',
    isa      => 'Jikkoku::Service::BattleCommand::Battle::CharaPower::CharaPower',
    required => 1,
  );

  has '_base_max_take_damage' => ( is => 'rw', isa => 'Int', lazy => 1, builder => '_build_base_max_take_damage' );
  has '_orig_max_take_damage' => ( is => 'rw', isa => 'Int', lazy => 1, builder => '_build_orig_max_take_damage' );
  has 'max_take_damage'       => ( is => 'rw', isa => 'Int', lazy => 1, builder => '_build_max_take_damage' );
  has 'take_damage'           => ( is => 'rw', default => 0 );
  has 'first_soldier_num'     => ( is => 'ro', isa => 'Int', builder => '_build_first_soldier_num' );
  has 'increase_contribute'   => ( is => 'rw', isa => 'Num', default => 0 );
  has 'event_executers'       => ( is => 'ro', lazy => 1, builder => '_build_event_executers' );

  sub BUILD {
    my $self = shift;
    # 後で値が変わる可能性もあるので, 生成後に値をセットしておく
    $self->_base_max_take_damage;
    $self->_orig_max_take_damage;
  }

  sub _build_base_max_take_damage {
    my $self = shift;
    int( ($self->power->attack_power - $self->target_power->defence_power) / 10 );
  }

  sub _build_orig_max_take_damage {
    my $self = shift;
    my $damage  = $self->_base_max_take_damage;
    $damage = 0 if $damage < 0;
    $damage += ADJUST_MAX_TAKE_DAMAGE;
    $damage;
  }

  sub _build_max_take_damage {
    my $self = shift;
    $self->orig_max_take_damage;
  }

  sub _build_first_soldier_num {
    my $self = shift;
    $self->soldier->num;
  }

  sub _build_event_executers {
    my $self = shift;
    $self->skills
      ->get_available_skills_with_result
      ->get_battle_event_executer_skills_with_result;
  }

  sub update_orig_max_take_damage {
    my $self = shift;
    $self->power->update_power;
    $self->target_power->update_power;
    $self->_base_max_take_damage( $self->_build_base_max_take_damage );
    $self->_orig_max_take_damage( $self->_build_orig_max_take_damage );
  }

  sub init_max_take_damage {
    my $self = shift;
    $self->max_take_damage( $self->_orig_max_take_damage );
  }

  sub update_take_damage {
    my $self = shift;
    my $take_damage = $self->can_take_damage ? int( rand $self->max_take_damage ) + 1 : 0;
    $self->take_damage($take_damage);
  }

  sub record_increase_contribute {
    my ($self, $target) = @_;
    $self->increase_contribute( $self->increase_contribute + $target->first_soldier_num - $target->soldier->num );
  }

  sub soldier_status {
    my $self = shift;
    qq{@{[ $self->name ]} @{[ $self->soldier->name ]} (@{[ $self->soldier->attr]}) @{[ $self->soldier->num ]}人};
  }

  sub power_status {
    my $self = shift;
    qq{[@{[ $self->is_invasion ? '侵攻' : '防衛' ]}] 【@{[ $self->name ]} [@{[ $self->formation->name ]}] (攻:@{[ $self->power->attack_power ]} 守:@{[ $self->power->defence_power ]}) 】};
  }

  __PACKAGE__->meta->make_immutable;

}

1;

__END__

=head2 CONSTANTS

=head3 C<ADJUST_MAX_TAKE_DAMAGE : Int>
  
  最大与ダメージを調節するための数値。(=1)
  最大与ダメージはbase_max_take_damage + 1

=head2 ACCESSORS

=head3 C<_base_max_take_damage : Int>
  
  基礎となる最大与ダメージ。

=head3 C<_orig_max_take_damage : Int>

  乱数とゲーム向けに調整した最大与ダメージ。
  base_max_take_damageが0以下の際、敵を回復しないようにする調整している。

=head3 C<max_take_damage : Int>
  
  最大与えるダメージ。
  外部から変更しても良い。


=cut

