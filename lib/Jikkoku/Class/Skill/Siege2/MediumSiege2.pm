package Jikkoku::Class::Skill::Siege2::MediumSiege2 {

  use Mouse;
  use Jikkoku;

  use constant {
    ACQUIRE_SIGN        => 1,
    ACQUIRE_SIEGE_COUNT => 30,
  };

  has 'name'          => ( is => 'ro', isa => 'Str', default => '攻城2【中】' );
  has 'increase_turn' => ( is => 'ro', isa => 'Int', default => 2 );

  with qw(
    Jikkoku::Class::Skill::Skill
    Jikkoku::Class::Skill::Role::Practice
    Jikkoku::Class::Skill::Siege2::Siege2
  );

  around _build_next_skills_id => sub { ['GreatSiege2'] };

  # 上位互換のスキルのみ有効にするため, 
  # 上位のスキルを修得しているときはこのスキルを無効化する
  around is_available => sub {
    my ($orig, $self) = @_;
    $self->$orig() && grep { !$self->chara->skills->get({category => $self->category, id => $_})->is_acquired } @{ $self->next_skills_id };
  };

  __PACKAGE__->meta->make_immutable;

}

1;

