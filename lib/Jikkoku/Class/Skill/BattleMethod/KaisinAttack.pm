package Jikkoku::Class::Skill::BattleMethod::KaisinAttack {

  use Mouse;
  use Jikkoku;

  use constant ACQUIRE_SIGN => 2;

  has 'name'                  => ( is => 'ro', isa => 'Str', default => '会心攻撃' );
  has 'consume_skill_point'   => ( is => 'ro', isa => 'Int', default => 10 );
  has 'occur_ratio_coef'      => ( is => 'ro', isa => 'Num', default => 0.001 );
  has 'max_occur_ratio'       => ( is => 'ro', isa => 'Num', default => 0.33 );
  has 'increase_damage_ratio' => ( is => 'ro', isa => 'Num', default => 1.5 );
  has 'range'                 => ( is => 'ro', isa => 'Int', lazy => 1, default => sub { $_[0]->chara->soldier->reach } );

  with qw( Jikkoku::Class::Skill::BattleMethod::BattleLoopEventExecuter );

  around next_skills_id => sub { ['Storm'] };

  around description_of_effect_body => sub {
    my ($orig, $self) = @_;
    '発動したターン最大ダメージが' . $self->increase_damage_ratio . '倍される。';
  };

  __PACKAGE__->prepare;
  __PACKAGE__->meta->make_immutable;

}

1;

