package Jikkoku::Class::Skill::Command::Charge {

  use Mouse;
  use Jikkoku;

  use constant {
    ACQUIRE_SIGN => 0,
  };
  
  has 'name'                => ( is => 'ro', isa => 'Str', default => '突撃' );
  has 'consume_skill_point' => ( is => 'ro', isa => 'Int', default => 5 );
  has 'occur_ratio_coef'    => ( is => 'ro', isa => 'Num', default => 0.0011 );
  has 'max_occur_ratio'     => ( is => 'ro', isa => 'Num', default => 0.35 );
  has 'range'               => ( is => 'ro', isa => 'Int', default => 1 );

  with qw( Jikkoku::Class::Skill::Command::BattleLoopEventExecuter );

  around next_skills_id => sub {
    [qw/ Offensive Close /];
  };

  around description_of_effect_body => sub {
    '相手にダメージを与える。';
  };

  __PACKAGE__->prepare;
  __PACKAGE__->meta->make_immutable;

}

1;
