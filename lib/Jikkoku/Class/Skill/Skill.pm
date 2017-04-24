package Jikkoku::Class::Skill::Skill {

  use Mouse::Role;
  use Jikkoku;
  use Jikkoku::Model::SkillCategory;

  # attribute
  requires qw( name );

  has 'id'               => ( is => 'rw', isa => 'Str', lazy => 1, builder => '_build_id' );
  has 'category'         => ( is => 'rw', isa => 'Str', lazy => 1, builder => '_build_category' );
  has 'next_skills_id'   => ( is => 'rw', isa => 'ArrayRef[Str]', lazy => 1, builder => '_build_next_skills_id' );
  has 'before_skills_id' => ( is => 'rw', isa => 'ArrayRef[Str]', lazy => 1, builder => '_build_before_skills_id' );

  sub _build_id {
    my $self = shift;
    my $class = ref $self;
    (split /::/, $class)[-1];
  }

  sub _build_category {
    my $self = shift;
    my $class = ref $self;
    (split /::/, $class)[-2];
  }

  sub _build_next_skills_id   { [] }

  sub _build_before_skills_id { [] }

  # method
  requires qw(
    acquire
    is_acquired
    explain_status
    explain_acquire
  );

  {
    my @methods = qw(
      explain_effect_about_state
      explain_effect_body
      explain_effect_supplement
      explain_effect_about_depend_abilities
    );

    __PACKAGE__->meta->add_method($_ => sub { '' }) for @methods;
    
    sub explain_effect {
      my $self = shift;
      join "<br>\n", grep { $_ ne '' } map { $self->$_ } @methods;
    }
  }

  before acquire => sub {
    my $self = shift;
    my $skill_category_model = Jikkoku::Model::SkillCategory->new;
    my $skill_category       = $skill_category_model->get_skill_category({
      id          => $self->category,
      skill_model => $self->chara->skills,
    });
    my $before_skills_id = $skill_category->get_before_skills_id($self);
    for my $skill_id (@$before_skills_id) {
      my $skill = $skill_category->get_chached_skill($skill_id);
      unless ($skill->is_acquired) {
        Jikkoku::Class::Role::BattleActionException
          ->throw("修得条件を満たしていません(@{[ $skill->name ]}を修得していないため)");
      }
    }
  };

}

1;
