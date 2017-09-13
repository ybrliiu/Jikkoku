package Jikkoku::Class::Skill::Invasion {

  use Mouse;
  use Jikkoku;

  has 'name'          => ( is => 'ro', isa => 'Str', default => '侵攻' );
  has 'root_skill_id' => ( is => 'ro', isa => 'Str', default => 'IntensifyInvasion' );

  with 'Jikkoku::Class::Skill::SkillCategory';

  around _build_target_type => sub {
    ['武官'];
  };

  sub description {
    my $self = shift;
    '侵攻側の時の戦闘を有利に進められるようになるスキルです。';
  }

  __PACKAGE__->meta->make_immutable;

}

1;
