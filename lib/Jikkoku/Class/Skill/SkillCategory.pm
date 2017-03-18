package Jikkoku::Class::Skill::SkillCategory {

  use Mouse::Role;
  use Jikkoku;
  use Jikkoku::Util;

  # attribute
  requires qw( name root_skill_id );

  has 'target_type' => ( is => 'ro', isa => 'ArrayRef[Str]', lazy => 1, builder => '_build_target_type' );
  has 'skill_model' => ( is => 'ro', isa => 'Jikkoku::Model::Skill', weak_ref => 1, required => 1 );

  sub _build_target_type { [] }

  # method
  requires qw( description );

  sub id {
    my $self = shift;
    my $class = ref $self || $self;
    (split /::/, $class)[-1];
  }

  sub get_skill_with_option {
    my ($self, $id) = @_;
    $self->skill_model->get_skill_with_option({
      id       => $id,
      category => $self->id,
    });
  }

  sub get_next_skill {
    my ($self, $id) = @_;
    $self->skill_model->get_next_skill({
      id       => $id,
      category => $self->id,
    });
  }

  sub trace_skill_to_acquire_order {
    my $self = shift;
    $self->_trace( $self->get_next_skill($self->root_skill_id) );
  }

  sub _trace {
    my ($self, $next_skill) = @_;
    for my $skill (@$next_skill) {
      $self->_trace( $self->get_next_skill($skill->id) );
    }
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

