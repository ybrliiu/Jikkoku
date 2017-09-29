package Jikkoku::Class::Skill::BattleMethod::SacrificeAttack {

  use Mouse;
  use Jikkoku;

  use constant ACQUIRE_SIGN => 3;

  has 'name'                       => ( is => 'ro', isa => 'Str', default => '犠牲攻撃' );
  has 'consume_skill_point'        => ( is => 'ro', isa => 'Int', default => 15 );
  has 'occur_ratio_coef'           => ( is => 'ro', isa => 'Num', default => 0.001 );
  has 'max_occur_ratio'            => ( is => 'ro', isa => 'Num', default => 0.33 );
  has 'take_damage_ratio'          => ( is => 'ro', isa => 'Int', default => 3 );
  has 'take_damage_ratio_on_siege' => ( is => 'ro', isa => 'Int', default => 10 );
  has 'range'                      => ( is => 'ro', isa => 'Int', lazy => 1, default => sub { $_[0]->chara->soldier->reach } );

  with qw( Jikkoku::Class::Skill::BattleMethod::BattleLoopEventExecuter );

  around is_available => sub {
    my ($orig, $self) = @_;
    $self->$orig() && $self->chara->_config->get('is_sacrifice_attack_available');
  };

  around description_of_effect_body => sub {
    my ($orig, $self) = @_;
    '自軍の兵士を何人か犠牲にし、相手に犠牲になった兵士×' . $self->take_damage_ratio
      . 'のダメージを与える。(城壁戦は犠牲にした兵士×' . $self->take_damage_ratio_on_siege . ')';
  };

  __PACKAGE__->meta->make_immutable;

}

1;

