package Jikkoku::Class::Skill::Skill {

  use Mouse::Role;
  use Jikkoku;

  requires qw( name );

  has 'next_skill' => (is => 'rw', lazy => 1, builder => '_build_next_skill');

  requires qw(
    acquire
    is_acquired
    explain_effect
    explain_status
    explain_acquire
  );

  sub _build_next_skill { [] }

}

1;
