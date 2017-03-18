package Jikkoku::Class::Skill::Skill {

  use Mouse::Role;
  use Jikkoku;

  # attribute
  requires qw( name );

  has 'next_skill'       => ( is => 'rw', isa => 'ArrayRef[Str]', lazy => 1, builder => '_build_next_skill');
  has 'before_skill'     => ( is => 'rw', isa => 'ArrayRef[Str]', lazy => 1, builder => '_build_before_skill');

  sub _build_next_skill       { [] }
  sub _build_before_skill     { [] }

  # method
  requires qw(
    acquire
    is_acquired
    explain_effect
    explain_status
    explain_acquire
  );

  sub id {
    my $self = shift;
    my $class = ref $self || $self;
    (split /::/, $class)[-1];
  }

  sub category {
    my $self = shift;
    my $class = ref $self || $self;
    (split /::/, $class)[-2];
  }

}

1;
