package Jikkoku::Class::Skill::AssistMove::Avoid {

  use Mouse;
  use Jikkoku;

  use constant ACQUIRE_SIGN => 4;

  has 'name'                => ( is => 'ro', isa => 'Str', default => '回避' );
  has 'range'               => ( is => 'ro', isa => 'Int', default => 1 ); # 不必要
  has 'max_occur_ratio'     => ( is => 'ro', isa => 'Num', default => 0.33 );
  has 'occur_ratio_coef'    => ( is => 'ro', isa => 'Num', default => 0.0011 );
  has 'consume_skill_point' => ( is => 'ro', isa => 'Int', default => 15 );

  with qw(
    Jikkoku::Class::Skill::AssistMove::AssistMove
    Jikkoku::Class::Skill::Role::BattleLoopEventExecuter::DependOnAbilities
  );

  sub _build_items_of_depend_on_abilities { ['発動率'] }

  around description_of_effect_body => sub {
    my ($orig, $self) = @_;
    qq{自軍は敵からの攻撃を完全に回避し、そのターン敵から受けるダメージが0になる。};
  };

  # __PACKAGE__->prepare;
  __PACKAGE__->meta->make_immutable;

}

1;

