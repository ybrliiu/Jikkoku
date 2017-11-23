package Jikkoku::Class::Skill::Command::RegroupFormation {

  use Mouse;
  use Jikkoku;
  use Jikkoku::Model::Config;

  use constant ACQUIRE_SIGN => 4;

  my $CONFIG = Jikkoku::Model::Config->get;
  
  has 'name'                       => ( is => 'ro', isa => 'Str', default => '陣形再編' );
  has 'success_ratio'              => ( is => 'ro', isa => 'Num', default => 1.0 );
  has 'consume_morale'             => ( is => 'ro', isa => 'Int', default => 25 );
  has 'action_interval_time'       => ( is => 'ro', isa => 'Int', default => $CONFIG->{game}{action_interval_time} * 0.5 );
  has 'consume_skill_point'        => ( is => 'ro', isa => 'Int', default => 15 );
  has 'num_of_divide_regroup_time' => ( is => 'ro', isa => 'Int', default => 4 );

  with qw(
    Jikkoku::Class::Skill::Command::Command
    Jikkoku::Class::Skill::Role::UsedInBattleMap
    Jikkoku::Class::Skill::Role::UsedInBattleMap::OccurActionTime
    Jikkoku::Class::Skill::Role::UsedInBattleMap::NotDependOnAbilities
  );

  around description_of_effect_body => sub {
    my ($orig, $self) = @_;
    "陣形の再編にかかる時間を使用時の1/@{[ $self->num_of_divide_regroup_time ]}に短縮する。";
  };

  __PACKAGE__->meta->make_immutable;

}

1;
