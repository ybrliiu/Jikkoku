package Jikkoku::Class::Skill::AssistMove::Syukuti {

  use Mouse;
  use Jikkoku;
  use Jikkoku::Model::Config;

  use constant ACQUIRE_SIGN => 1;

  my $CONFIG = Jikkoku::Model::Config->get;

  has 'name'                  => ( is => 'ro', isa => 'Str', default => '縮地' );
  has 'success_ratio'         => ( is => 'ro', isa => 'Num', default => 0.65 );
  has 'max_success_ratio'     => ( is => 'ro', isa => 'Num', default => 0.9 );
  has 'consume_morale'        => ( is => 'ro', isa => 'Int', default => 7 );
  has 'consume_skill_point'   => ( is => 'ro', isa => 'Int', default => 7 );
  has 'action_interval_time'  => ( is => 'ro', isa => 'Int', default => $CONFIG->{game}{action_interval_time} * 0.75 );

  with qw(
    Jikkoku::Class::Skill::AssistMove::AssistMove
    Jikkoku::Class::Skill::Role::UsedInBattleMap::OccurActionTime
    Jikkoku::Class::Skill::Role::UsedInBattleMap::DependOnAbilities
  );

  sub _build_items_of_depend_on_abilities { [qw/ 短縮する時間 成功率 /] }

  around description_of_effect_body => sub {
    my ($orig, $self) = @_;
    "陣形の再編にかかる時間を使用時の1/@{[ $self->num_of_divide_regroup_time ]}に短縮する。";
#  $i_hojyo = "<TR><TD bgcolor=$TD_C2><b>縮地</b></TD><TD bgcolor=$TD_C2>味方の移動ポイント補充時間を<b>$syukuti</b>秒短縮する。<br>短縮する時間、成功率は人望に依存。(行動)</TD><TD bgcolor=$TD_C2>スキル修得ページでSPを7消費して修得。</TD><TD bgcolor=$TD_C2>待機時間：<b>$koutime5</b>秒<br>成功率：<b>$syuku_seikou</b>%<br>リーチ：4<br>消費士気：$MOR_SYUKUTI</TD></TR>";
  };

  __PACKAGE__->meta->make_immutable;

}

1;

