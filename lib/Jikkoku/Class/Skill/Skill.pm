package Jikkoku::Class::Skill::Skill {

  use Mouse::Role;
  use Jikkoku;

  requires qw( name );

  has 'before_skill' => (is => 'rw', lazy => 1, builder => '_build_before_skill');
  has 'next_skill'   => (is => 'rw', lazy => 1, builder => '_build_next_skill');

  requires qw(
    acquire
    is_acquired
    explain_effect
    explain_status
    explain_acquire
  );

  sub _build_before_skill { [] }

  sub _build_next_skill { [] }

  around acquire => sub {
    my ($orig, $self) = @_;
  };

}

1;
