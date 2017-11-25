package Jikkoku::Class::Skill::AssistMove::Kintoun {

  use Mouse;
  use Jikkoku;
  use Jikkoku::Model::Config;

  use constant ACQUIRE_SIGN => 3;

  my $CONFIG = Jikkoku::Model::Config->get;

  has 'name'                  => ( is => 'ro', isa => 'Str', default => '觔斗雲' );
  has 'range'                 => ( is => 'ro', isa => 'Int', default => 4 );
  has 'success_ratio'         => ( is => 'ro', isa => 'Num', default => 0.45 );
  has 'max_success_ratio'     => ( is => 'ro', isa => 'Num', default => 0.9 );
  has 'consume_morale'        => ( is => 'ro', isa => 'Int', default => 15 );
  has 'consume_skill_point'   => ( is => 'ro', isa => 'Int', default => 15 );
  has 'action_interval_time'  => ( is => 'ro', isa => 'Int', default => int($CONFIG->{game}{action_interval_time} * 0.75) );
  has 'min_effect_time_ratio' => ( is => 'ro', isa => 'Num', default => 3.0 );
  has 'max_effect_time_ratio' => ( is => 'ro', isa => 'Num', default => 6.0 );

  with qw(
    Jikkoku::Class::Skill::AssistMove::AssistMove
    Jikkoku::Class::Skill::Role::GiveState
    Jikkoku::Class::Skill::Role::UsedInBattleMap::OccurActionTime
    Jikkoku::Class::Skill::Role::UsedInBattleMap::ToOneChara::ToAlly
    Jikkoku::Class::Skill::Role::UsedInBattleMap::DependOnAbilities::SustainingEffect
  );

  sub _build_items_of_depend_on_abilities { [qw/ 効果持続時間 成功率 /] }

  around description_of_effect_about_state => sub {
    my ($orig, $self) = @_;
    my $state = $self->state;
    << "EOS";
@{[ $self->TARGET_TYPE ]}@{[ $self->TARGET_NUM ]}に@{[ $state->name ]}を付与し、消費移動Pが多い地形での消費移動Pを抑える。<br>
(効果 : @{[ $state->description ]})
EOS
  };

  __PACKAGE__->meta->make_immutable;

}

1;

