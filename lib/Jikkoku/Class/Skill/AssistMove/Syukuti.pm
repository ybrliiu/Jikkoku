package Jikkoku::Class::Skill::AssistMove::Syukuti {

  use Mouse;
  use Jikkoku;
  use Jikkoku::Model::Config;

  use constant ACQUIRE_SIGN => 1;

  my $CONFIG = Jikkoku::Model::Config->get;

  has 'name'                  => ( is => 'ro', isa => 'Str', default => '縮地' );
  has 'range'                 => ( is => 'ro', isa => 'Int', default => 4 );
  has 'success_ratio'         => ( is => 'ro', isa => 'Num', default => 0.65 );
  has 'max_success_ratio'     => ( is => 'ro', isa => 'Num', default => 0.9 );
  has 'consume_morale'        => ( is => 'ro', isa => 'Int', default => 7 );
  has 'consume_skill_point'   => ( is => 'ro', isa => 'Int', default => 7 );
  has 'action_interval_time'  => ( is => 'ro', isa => 'Int', default => int($CONFIG->{game}{action_interval_time} * 0.75) );
  has 'shortening_coef'       => ( is => 'ro', isa => 'Num', default => 0.2 );

  with qw(
    Jikkoku::Class::Skill::AssistMove::AssistMove
    Jikkoku::Class::Skill::Role::UsedInBattleMap::OccurActionTime
    Jikkoku::Class::Skill::Role::UsedInBattleMap::DependOnAbilities
    Jikkoku::Class::Skill::Role::UsedInBattleMap::ToOneChara::ToAlly
  );

  sub _build_items_of_depend_on_abilities { [qw/ 短縮する時間 成功率 /] }

  around next_skills_id => sub { ['Acceleration'] };

  sub shortening_time {
    my $self = shift;
    $self->chara->popular * $self->shortening_coef;
  }

  around description_of_effect_body => sub {
    my ($orig, $self) = @_;
    qq{味方の移動ポイント補充時間を<strong>@{[ $self->shortening_time ]}</strong>秒短縮する。};
  };

  __PACKAGE__->meta->make_immutable;

}

1;

