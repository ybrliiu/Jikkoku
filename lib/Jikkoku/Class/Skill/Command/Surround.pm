package Jikkoku::Class::Skill::Command::Surround {

  use Mouse;
  use Jikkoku;

  use constant ACQUIRE_SIGN => 3;
  
  has 'name'                => ( is => 'ro', isa => 'Str', default => '包囲' );
  has 'consume_skill_point' => ( is => 'ro', isa => 'Int', default => 15 );

  with qw(
    Jikkoku::Class::Skill::Command::Command
    Jikkoku::Class::Skill::Role::BattleMode
  );

  around description_of_effect_body => sub {
    my ($orig, $self) = @_;
    "戦闘モード@{[ $self->battle_mode->name ]}使用可能。";
  };

  __PACKAGE__->meta->make_immutable;

}

1;
