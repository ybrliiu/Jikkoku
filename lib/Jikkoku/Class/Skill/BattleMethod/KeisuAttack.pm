package Jikkoku::Class::Skill::BattleMethod::KeisuAttack {

  use Mouse;
  use Jikkoku;

  use constant {
    ACQUIRE_SIGN          => 0,
    PLUS_TAKE_DAMAGE      => 3,
    INCREASE_DAMAGE_LIMIT => 15,
  };

  has 'name'                => ( is => 'ro', isa => 'Str', default => '計数攻撃' );
  has 'consume_skill_point' => ( is => 'ro', isa => 'Int', default => 5 );
  has 'occur_ratio_coef'    => ( is => 'ro', isa => 'Num', default => 0.0011 );
  has 'max_occur_ratio'     => ( is => 'ro', isa => 'Num', default => 0.35 );
  has 'range'               => ( is => 'ro', isa => 'Int', lazy => 1, default => sub { $_[0]->chara->soldier->reach } );

  with qw( Jikkoku::Class::Skill::BattleMethod::BattleLoopEventExecuter );

  around next_skills_id => sub { [qw/ DestroyAttack KaisinAttack /] };

  around description_of_effect_body => sub {
    my ($orig, $self) = @_;
    '出撃中' . $self->name . 'が発動した回数+' . $self->PLUS_TAKE_DAMAGE . 'ダメージ与える。'
      . '(ただしダメージが増えるのは発動回数' . $self->INCREASE_DAMAGE_LIMIT . '回まで。)';
  };

  __PACKAGE__->meta->make_immutable;

}

1;

