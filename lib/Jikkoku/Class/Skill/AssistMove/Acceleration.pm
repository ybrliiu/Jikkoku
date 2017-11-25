package Jikkoku::Class::Skill::AssistMove::Acceleration {

  use Mouse;
  use Jikkoku;
  use Jikkoku::Model::Config;

  use constant {
    ACQUIRE_SIGN         => 2,
    ADD_MOVE_POINT_LIMIT => 50,
    ADD_MOVE_POINT_COEF  => 0.03,
    MAX_ADD_MOVE_POINT   => 10,
  };

  my $CONFIG = Jikkoku::Model::Config->get;

  has 'name'                  => ( is => 'ro', isa => 'Str', default => '加速' );
  has 'range'                 => ( is => 'ro', isa => 'Int', default => 5 );
  has 'success_ratio'         => ( is => 'ro', isa => 'Num', default => 0.55 );
  has 'max_success_ratio'     => ( is => 'ro', isa => 'Num', default => 0.95 );
  has 'consume_morale'        => ( is => 'ro', isa => 'Int', default => 7 );
  has 'consume_skill_point'   => ( is => 'ro', isa => 'Int', default => 13 );
  has 'action_interval_time'  => ( is => 'ro', isa => 'Int', default => int($CONFIG->{game}{action_interval_time} * 0.66) );

  with qw(
    Jikkoku::Class::Skill::AssistMove::AssistMove
    Jikkoku::Class::Skill::Role::UsedInBattleMap::OccurActionTime
    Jikkoku::Class::Skill::Role::UsedInBattleMap::DependOnAbilities
    Jikkoku::Class::Skill::Role::UsedInBattleMap::ToOneChara::ToAlly
  );

  sub _build_items_of_depend_on_abilities { [qw/ プラスする移動ポイント 成功率 /] }

  around next_skills_id => sub { [qw/ Kintoun Avoid /] };

  sub add_move_point {
    my $self = shift;
    my $add_point = $self->chara->popular * $self->ADD_MOVE_POINT_COEF;
    $add_point > $self->MAX_ADD_MOVE_POINT ? $self->MAX_ADD_MOVE_POINT : $add_point;
  }

  around description_of_effect_body => sub {
    my ($orig, $self) = @_;
    qq{味方の移動ポイントを上限を超えて+<strong>@{[ $self->add_move_point ]}</strong>する。};
  };

  around description_of_effect_note => sub {
    my ($orig, $self) = @_;
    qq{※移動ポイントは@{[ $self->ADD_MOVE_POINT_LIMIT ]}まで増やせる。};
  };

  __PACKAGE__->meta->make_immutable;

}

1;

