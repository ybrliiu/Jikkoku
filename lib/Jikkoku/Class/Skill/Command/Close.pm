package Jikkoku::Class::Skill::Command::Close {

  use Mouse;
  use Jikkoku;

  use constant {
    ACQUIRE_SIGN                         => 2,
    INCREASE_DEFENCE_POWER               => 10,
    INCREASE_DEFENCE_POWER_LIMIT         => 50,
    NUM_OF_DIVIDE_OCCUR_RATIO_WHEN_SIEGE => 2,
  };
  
  has 'name'                => ( is => 'ro', isa => 'Str', default => '密集' );
  has 'consume_skill_point' => ( is => 'ro', isa => 'Int', default => 10 );
  has 'occur_ratio_coef'    => ( is => 'ro', isa => 'Num', default => 0.00833 );
  has 'max_occur_ratio'     => ( is => 'ro', isa => 'Num', default => 0.3 );
  has 'range'               => ( is => 'ro', isa => 'Int', lazy => 1, default => sub { $_[0]->chara->soldier->reach } );

  with qw( Jikkoku::Class::Skill::Command::BattleLoopEventExecuter );

  around next_skills_id => sub {
    ['Surround'];
  };

  around description_of_effect_body => sub {
    "発動毎に守備力が+@{[ INCREASE_DEFENCE_POWER ]}される。";
  };

  around description_of_effect_note => sub {
    << "EOS";
※上昇した守備力は撤退すると元に戻る。<br>
※1回の出撃中に上昇する守備力は@{[ INCREASE_DEFENCE_POWER_LIMIT ]}まで。<br>
※攻城戦は発動率が1/@{[ NUM_OF_DIVIDE_OCCUR_RATIO_WHEN_SIEGE ]}になる。
EOS
  };

  __PACKAGE__->prepare;
  __PACKAGE__->meta->make_immutable;

}

1;
