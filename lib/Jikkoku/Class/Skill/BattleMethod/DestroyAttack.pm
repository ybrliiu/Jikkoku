package Jikkoku::Class::Skill::BattleMethod::DestoryAttack {

  use Mouse;
  use Jikkoku;

  use constant ACQUIRE_SIGN => 1;

  has 'name'                => ( is => 'ro', isa => 'Str', default => '破壊攻撃' );
  has 'consume_skill_point' => ( is => 'ro', isa => 'Int', default => 10 );
  has 'occur_ratio_coef'    => ( is => 'ro', isa => 'Num', default => 0.0003 );
  has 'max_occur_ratio'     => ( is => 'ro', isa => 'Num', default => 0.1 );
  has 'range'               => ( is => 'ro', isa => 'Int', lazy => 1, default => sub { $_[0]->chara->soldier->reach } );

  with qw( Jikkoku::Class::Skill::BattleMethod::BattleLoopEventExecuter );

  around next_skills_id => sub { ['SacrificeAttack'] };

  around description_of_effect_before_body => sub { '戦闘中に低確率でイベント発生。' };

  around description_of_effect_body => sub { '相手に大ダメージを与える。' };

  __PACKAGE__->meta->make_immutable;

}

1;

