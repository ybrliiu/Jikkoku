# 足止めスキル

package Jikkoku::Class::Skill::Disturb::Stuck {

  use Mouse;
  use Jikkoku;
  
  use Jikkoku::Util qw( validate_values );
  use Jikkoku::Model::Config;
  my $CONFIG = Jikkoku::Model::Config->get;

  use constant ACQUIRE_SIGN => 2;

  has 'name'                  => ( is => 'ro', default => '足止め' );
  has 'range'                 => ( is => 'ro', default => 5 );
  has 'success_ratio'         => ( is => 'ro', default => 0.005 );
  has 'max_success_ratio'     => ( is => 'ro', default => 0.8 );
  has 'consume_morale'        => ( is => 'ro', default => 12 );
  has 'min_effect_time_ratio' => ( is => 'ro', default => 2.5 );
  has 'max_effect_time_ratio' => ( is => 'ro', default => 3.5 );
  has 'action_interval_time'  => ( is => 'ro', default => $CONFIG->{game}{action_interval_time} * 0.5 );
  has 'consume_skill_point'   => ( is => 'ro', default => 10 );
  has 'depend_abilities'      => ( is => 'ro', lazy => 1, default => sub { ['intellect'] } );

  with qw(
    Jikkoku::Class::Skill::Skill
    Jikkoku::Class::Skill::Role::UsedInBattleMap::OccurActionTime
    Jikkoku::Class::Skill::Role::UsedInBattleMap::ToOneChara::ToEnemy
    Jikkoku::Class::Skill::Role::UsedInBattleMap::DependOnAbilities::SustainingEffect
    Jikkoku::Class::Skill::Role::UsedInBattleMap::Purchasable
    Jikkoku::Class::Skill::Role::GiveState
  );

  # around _build_next_skills_id => sub { [ 'MakingMischief' ] };

  sub _build_items_of_depend_on_abilities {
    [qw/ 成功率 効果時間 /];
  }

  sub is_acquired {
    my $self = shift;
    $self->chara->skill('disturb') >= ACQUIRE_SIGN;
  }

  sub acquire {
    my $self = shift;
    $self->chara->skill(disturb => ACQUIRE_SIGN);
  }

  __PACKAGE__->meta->make_immutable;

}

1;
