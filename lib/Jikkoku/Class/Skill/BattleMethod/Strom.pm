package Jikkoku::Class::Skill::BattleMethod::Storm {

  use Mouse;
  use Jikkoku;

  use constant ACQUIRE_SIGN => 4;

  has 'name'                       => ( is => 'ro', isa => 'Str', default => '強襲' );
  has 'consume_skill_point'        => ( is => 'ro', isa => 'Int', default => 15 );

  with qw( Jikkoku::Class::Skill::BattleMethod::BattleMethod );

  around description_of_effect_body => sub {
    my ($orig, $self) = @_;
    '';
  };

  __PACKAGE__->meta->make_immutable;

}

1;

