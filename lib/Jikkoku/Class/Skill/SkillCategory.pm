package Jikkoku::Class::Skill::SkillCategory {

  use Mouse::Role;
  use Jikkoku;
  use Jikkoku::Util;
  use List::Util;

  # attribute
  requires qw( name root_skill_id );

  has 'id'          => ( is => 'rw', isa => 'Str', lazy => 1, builder => '_build_id' );
  has 'target_type' => ( is => 'ro', isa => 'ArrayRef[Str]', lazy => 1, builder => '_build_target_type' );
  has 'skill_model' => ( is => 'ro', isa => 'Jikkoku::Model::Skill', weak_ref => 1, required => 1 );

  sub _build_id {
    my $self = shift;
    my $class = ref $self;
    (split /::/, $class)[-1];
  }

  sub _build_target_type { [] }

  # method
  requires qw( description );

  around description => sub {
    my ($orig, $self) = @_;
    $self->description_target_type . $self->$orig();
  };

  sub description_target_type {
    my $self = shift;
    my @target_types = @{ $self->_build_target_type };
    return '' if @target_types == 0;
    join(@target_types == 1 ? '' : '及び', @target_types) . '向けの、';
  }

  sub get_skill {
    my ($self, $id) = @_;
    $self->skill_model->get({
      id       => $id,
      category => $self->id,
    });
  }

  sub get_chached_skill {
    my ($self, $id) = @_;
    $self->skill_model->get_chached_skill({
      id       => $id,
      category => $self->id,
    });
  }

  sub get_before_skills_id {
    my ($self, $skill) = @_;
    my ($seted_skill) = grep { $skill->id eq $_->id } @{ $self->get_belong_skills_with_set_before_skills };
    $seted_skill->before_skills_id;
  }

  sub get_belong_skills_with_set_before_skills {
    my $self = shift;
    my $root_skill = $self->get_skill($self->root_skill_id);
    my @skills = $self->_trace_belong_skills_with_set_before_skills($root_skill);
    unshift @skills, $root_skill;
    \@skills;
  } 

  sub _trace_belong_skills_with_set_before_skills {
    my ($self, $skill) = @_;
    map {
      my $next_skill_id = $_;
      my $next_skill = $self->get_skill($next_skill_id);
      push @{ $next_skill->before_skills_id }, $skill->id;
      ( $next_skill, $self->_trace_belong_skills_with_set_before_skills( $next_skill ) );
    } @{ $skill->next_skills_id };
  }

  sub get_belong_skills {
    my $self = shift;
    my $root_skill = $self->get_skill($self->root_skill_id);
    my @skills = $self->_trace_belong_skills($root_skill);
    unshift @skills, $root_skill;
    \@skills;
  }

  sub _trace_belong_skills {
    my ($self, $skill) = @_;
    map {
      my $next_skill_id = $_;
      my $next_skill = $self->get_skill($next_skill_id);
      ( $next_skill, $self->_trace_belong_skills( $next_skill ) );
    } @{ $skill->next_skills_id };
  }

  sub trace_skill_to_acquire_order {
    my $self = shift;
    $self->_trace( $self->get_next_skill($self->root_skill_id) );
  }

  sub _trace {
    my ($self, $next_skill) = @_;
    map {
      my $skill = $_;
      $self->_trace( $self->get_next_skill($skill->id) );
    } @$next_skill;
  }

}

1;

__END__

=encoding utf8

=head1 NAME

Jikkoku::Class::Skill::SkillCategory

=head1 ATTRIBUTES

=head2 root_skill_id

スキルカテゴリに含まれるスキルで、最も最初に修得するスキルのID。
スキルのIDはスキルのクラス名の最後の文字列です
(例 : Jikkoku::Class::Skill::Disturb::Stuck -> 'Stuck')

=head2 target_type

どの官種向けのスキルかを表します。
必要に応じて builder method である _build_target_type を再定義してください。

=cut

