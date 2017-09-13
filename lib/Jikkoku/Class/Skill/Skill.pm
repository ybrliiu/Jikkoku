package Jikkoku::Class::Skill::Skill {

  use Mouse::Role;
  use Jikkoku;
  use Jikkoku::Model::SkillCategory;

  # attribute
  requires qw( name );

  has 'chara'    => ( is => 'ro', isa => 'Jikkoku::Class::Chara::ExtChara', weak_ref => 1, required => 1 );
  has 'id'       => ( is => 'ro', isa => 'Str', lazy => 1, builder => '_build_id' );
  has 'category' => ( is => 'ro', isa => 'Str', lazy => 1, builder => '_build_category' );

  # 使用先で定義
  has 'next_skills_id'   => ( is => 'ro', isa => 'ArrayRef[Str]', lazy => 1, builder => '_build_next_skills_id' );

  # skillcategory で使う用
  has 'before_skills_id' => ( is => 'ro', isa => 'ArrayRef[Str]', lazy => 1, builder => '_build_before_skills_id' );

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
  requires qw( acquire is_acquired );

  {
    my @methods = qw(
      description_of_effect_about_state
      description_of_effect_body
      description_of_effect_supplement
      description_of_effect_about_depend_abilities
    );

    __PACKAGE__->meta->add_method($_ => sub { '' }) for @methods;
    
    sub description_of_effect {
      my $self = shift;
      join "<br>\n", grep { $_ ne '' } map { $self->$_ } @methods;
    }
  }

  {
    my @methods = qw(
      description_of_status_about_range
      description_of_status_about_consume_morale
      description_of_status_body
      description_of_status_about_action_interval_time
      description_of_status_about_success_ratio
    );

    __PACKAGE__->meta->add_method($_ => sub { '' }) for @methods;

    sub description_of_status {
      my $self = shift;
      join "<br>\n", grep { $_ ne '' } map { $self->$_ } @methods;
    }
  }

  {
    my @methods = qw(
      description_of_acquire_body
      description_of_acquire_about_before_skills
      description_of_acquire_about_purchase
    );

    sub description_of_acquire_body()         { '' }

    sub description_of_acquire_about_purchase() { '' }

    sub description_of_acquire_about_before_skills {
      my $self = shift;
      join "<br>\n", map { $_->name . 'を修得していること。' } @{ $self->before_skills };
    }

    sub description_of_acquire {
      my $self = shift;
      join "<br>\n", grep { $_ ne '' } map { $self->$_ } @methods;
    }
  }

  sub before_skills {
    my $self = shift;
    my $skill_category_model = Jikkoku::Model::SkillCategory->new;
    my $skill_category       = $skill_category_model->get({
      id          => $self->category,
      skill_model => $self->chara->skills,
    });
    my $before_skills_id = $skill_category->get_before_skills_id($self);
    [ map { $skill_category->get_chached_skill($_) } @$before_skills_id ];
  }

  before acquire => sub {
    my $self = shift;
    my $skill_category_model = Jikkoku::Model::SkillCategory->new;
    my $skill_category       = $skill_category_model->get({
      id          => $self->category,
      skill_model => $self->chara->skills,
    });
    my $before_skills_id = $skill_category->get_before_skills_id($self);
    for my $skill_id (@$before_skills_id) {
      my $skill = $skill_category->get_chached_skill($skill_id);
      unless ($skill->is_acquired) {
        Jikkoku::Class::Skill::AcquireSkillException
          ->throw("修得条件を満たしていません(@{[ $skill->name ]}を修得していないため)");
      }
    }
  };

}

package Jikkoku::Class::Skill::AcquireSkillException {

  use Jikkoku;
  use parent 'Jikkoku::Exception';

}

1;
